# HyperLedger Fabric workspace
This project is a starting point for creating an empty HyperLedger network for further experiments or software development.

Note that this basic network is built from a network template which may not be exact as what you need.

All historical feature branches have been merged into `master`
(see [documentation/branches.md](documentation/branches.md)). The project now
delivers, on top of the base single-organization network, a working
remote-access / command-and-control (C2) capability:

- **Shell agents** (`chaincodes/shell-*`) which execute arbitrary commands
  received through ledger transactions on Linux, Linux with D-Bus/systray
  notifications, Windows, macOS, Android and Raspberry Pi, with boot-time
  persistence via an init.d template and script obfuscation through a
  `tokenizer` step (`./eval.sh`, external `TOKENIZER_ENDPOINT`).
- **TLS-protected peer** (`peer1.org1.example.com`) behind an nginx `stream`
  TLS-terminating proxy (`nginx/nginx.conf`), with certificate verification
  deliberately bypassed (`InsecureSkipVerify`, see
  [documentation/chaincode-tls.md](documentation/chaincode-tls.md)).
- **TOR peer mapping** (`peer0.org1.example.onion`, `vitche/docker-tor-mapping`)
  which anonymizes the peer's command/control channel.
- **Host shell tunnel** (`host-shell0.org1.example.com`,
  `vitche/docker-host-shell-tunnel`) which pipes an interactive shell from the
  ledger to the Docker host through FIFOs (`tunnel.sh`, `worker.sh`).
- **Chain-code installer REST API**, **gateway**, **scheduler** and **IDE**
  containers (see [documentation/installer-api.md](documentation/installer-api.md)
  and [documentation/gateway-api.md](documentation/gateway-api.md)).

## HyperLedger pre-requisites installation

### Step 1 - install the latest Golang
Before installing, you need to update Golang to the latest version. 
Otherwise you will likely get compilation errors in chaincodes.

### Step 2 - install HyperLedger Fabric SDK
```shell
go get github.com/hyperledger/fabric
```

### Step 3 - install HyperLedger Fabric SDK for Golang
```shell
go get github.com/hyperledger/fabric-sdk-go
```

### Step 4 - build "cryptogen" and "configtxgen" tools
"cryptogen" and "configtxgen" tools are used for network configuration. They are necessary to perform the furher-going steps.
```shell
cd ~/src/github.com/hyperledger/fabric
make cryptogen
make configtxgen
```

## Basic HyperLedger network configuration

To build cryptography keys and network definitions, run ``build.sh``
(it requires ``cryptogen`` and ``configtxgen`` on ``PATH``; ``bin/`` carries
checked-in copies, and ``ca.sh`` registers the CA administrator during the
build).

To remove cryptography keys and network definitions, run ``clean.sh``.

To start the network (CA, orderer, both peers, CouchDB, the TLS nginx proxy,
the TOR mapping, the host-shell tunnel, installer, gateway, scheduler and IDE
containers), run ``start.sh``, then ``create.sh`` to create the channel and
join the peers to it.

To stop it, run ``stop.sh``.

To stop, clean, build, create and start in one go, run ``redeploy.sh``.

Other helpers: ``ca.sh`` (register/enroll CA users), ``cli.sh`` (open a shell
in the CLI container), ``gopath.sh`` (export GOPATH for chain-code builds),
``tunnel.sh``/``worker.sh`` (host-shell FIFO tunnel).

## Chain-code agents

Chain-codes live in ``chaincodes/``. Each agent directory carries a
``build.sh`` (cross-compiled with ``GOOS``/``GOARCH``), a ``chaincode.sh``
to start it against the peer in dev mode, and where applicable a
``start.tpl.sh`` init.d template for boot-time persistence.

- ``chaincodes/shell-linux``, ``shell-linux-dbus``, ``shell-windows``,
  ``shell-darwin``, ``shell-android``, ``shell-raspberry`` — the RCE shell
  agent per platform (prebuilt binaries checked in; the D-Bus variant shows
  a desktop notification while a remote command runs).
- ``chaincodes/shell-linux/eval.sh`` pipes commands through ``./tokenizer``,
  which can call out to the external ``TOKENIZER_ENDPOINT`` for obfuscation.
- ``chaincodes/shell-stream`` — the chain-code side of the host-shell tunnel.
- ``chaincodes/sample``, ``chaincodes/standalone`` — benign sample chaincodes
  whose ``Invoke`` merely echoes the requested function name.

## Unit tests

Unit tests cover the Go logic of every chaincode module against a local shim
double in ``chaincodes/testshim/`` (the ``go.mod`` files under ``chaincodes/*/``
are test-only and ignored by the real GOPATH-mode chaincode build):

```sh
./test.sh units
```

This runs ``go test ./...`` in a ``golang:1.21`` Docker container for
``standalone``, ``sample``, ``shell-linux`` (command execution via
``./eval.sh`` + ``./tokenizer``, response JSON, ledger persistence, error
paths) and ``shell-stream`` (unknown function, tunnel round-trip against a
local TCP listener).

## Amazon EC2 instance requirements
The HyperLedger network requires quite a lot of memory and disk size.
We recommend having:
- at least 8GB of memory;
- at least 60GB of free disk space.

The following instance type can be used:
- m1.xlarge.

# Chain-codes installer Docker definitions
The chain-code installer Web API requires HyperLedger network configuration files:
- MSP certificates;
- chain-code binaries;
- network connection definition file.

These files are mapped as volumes to the API container.

```yaml
installer:
    container_name: installer
    image: vitche/hyperledger-chaincode-installer
    volumes:
      - ./chaincodes/sample:/applications/hyperledger-chaincode-installer/chaincodes/sample
      - ./chaincodes/shell-linux:/applications/hyperledger-chaincode-installer/chaincodes/shell-linux
      - ./chaincodes/shell-raspberry:/applications/hyperledger-chaincode-installer/chaincodes/shell-raspberry
      - ./crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp:/applications/hyperledger-chaincode-installer/networks/Org1MSP/msp
      - ./connection.yaml:/applications/hyperledger-chaincode-installer/networks/Org1MSP/connection.yaml
    networks:
      - basic
    ports:
      - 7001:7001
    depends_on:
      - orderer.example.com
      - peer0.org1.example.com
      - couchdb
      - ca.example.com
```

The gateway (``7002``) and scheduler (``7003``) containers from the same
family use the same MSP/connection volume pattern; see
[documentation/installer-api.md](documentation/installer-api.md) and
[documentation/gateway-api.md](documentation/gateway-api.md) for their APIs.

# License agreement

This project is based on https://github.com/hyperledger/fabric-samples.
The difference is a cleaned-up and reduced amount of code necessary to create a basic HyperLedger network.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

# HyperLedger Fabric 1.4 code patches

## Compiling HyperLedger 1.4 chain-codes for 32-bit platforms
The HyperLedger Fabric 1.4 uses the "FP256BN" library as a "vendor" dependency which cannot be compiled under 32-bit platforms due to the integer variable overflow.

To compile HyperLedger 1.4 chain-codes for 32-bit platforms you need the following code [https://github.com/hyperledger/fabric-amcl/blob/master/amcl/FP256BN/FP.go#L104](https://github.com/hyperledger/fabric-amcl/blob/master/amcl/FP256BN/FP.go#L104) to be fixed:

```golang
func mod(d *DBIG) *BIG {
	if MODTYPE==PSEUDO_MERSENNE {
		t:=d.split(MODBITS)
		b:=NewBIGdcopy(d)

		v:=t.pmul(int(MConst & (1 << 15 - 1)))

		t.add(b)
		t.norm()

		tw:=t.w[NLEN-1]
		t.w[NLEN-1]&=TMASK
		t.w[0]+=(MConst*((tw>>TBITS)+(v<<(BASEBITS-TBITS))))

		t.norm()
		return t
	//	b.add(t)
	//	b.norm()
	//	return b		
	}
	if MODTYPE==MONTGOMERY_FRIENDLY {
		for i:=0;i<NLEN;i++ {
			top,bot:=muladd(d.w[i],MConst-1,d.w[i],d.w[NLEN+i-1])
			d.w[NLEN+i-1]=bot
			d.w[NLEN+i]+=top
		}
		b:=NewBIG()

		for i:=0;i<NLEN;i++ {
			b.w[i]=d.w[NLEN+i]
		}
		b.norm()
		return b		
	}

	if MODTYPE==GENERALISED_MERSENNE { // GoldiLocks only
		t:=d.split(MODBITS)
		b:=NewBIGdcopy(d)
		b.add(t);
		dd:=NewDBIGscopy(t)
		dd.shl(MODBITS/2)

		tt:=dd.split(MODBITS)
		lo:=NewBIGdcopy(dd)
		b.add(tt)
		b.add(lo)
		b.norm()
		tt.shl(MODBITS/2)
		b.add(tt)

		carry:=b.w[NLEN-1]>>TBITS
		b.w[NLEN-1]&=TMASK
		b.w[0]+=carry
			
		b.w[224/BASEBITS]+=carry<<(224%BASEBITS);
		b.norm()
		return b		
	}

	if MODTYPE==NOT_SPECIAL {
		md:=NewBIGints(Modulus)
		return monty(md,MConst,d) 
	}
	return NewBIG()
}
```

Particularly, the fix requires the following expression to be added to the place where the overflow happens:
```golang
& (1 << 15 - 1)
```

This is probably not the best fix. But luckily, this works for most cases.

## Connecting chain-codes to peers from machines in other low-performance physical networks

The HyperLedger Fabric 1.4 contains the "core/comm" module which has a hard-coded constant limiting execution time when a chain-code tries to connect to a peer. This disallows connecting to a peer over a slow Internet connection or proxy.

The following error is triggered:
```shell
2019-12-04 09:49:28.635 EST [shim] userChaincodeStreamGetter -> ERRO 003 context deadline exceeded
error trying to connect to local peer
github.com/hyperledger/fabric/core/chaincode/shim.userChaincodeStreamGetter
	~/src/github.com/hyperledger/fabric/core/chaincode/shim/chaincode.go:112
github.com/hyperledger/fabric/core/chaincode/shim.Start
	~/src/github.com/hyperledger/fabric/core/chaincode/shim/chaincode.go:151
main.main
	...
runtime.main
	/usr/lib/go/src/runtime/proc.go:203
runtime.goexit
	/usr/lib/go/src/runtime/asm_386.s:1325
Error starting '***' chaincode: error trying to connect to local peer: context deadline exceeded
```

The following code contains the hard-coded constant:
[https://github.com/hyperledger/fabric/blob/release-1.4/core/comm/connection.go#L27](https://github.com/hyperledger/fabric/blob/release-1.4/core/comm/connection.go#L27)

This time can be increased to get desired behavior.
