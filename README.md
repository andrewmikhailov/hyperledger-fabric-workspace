# HyperLedger Fabric workspace
This project is a starting point for creating an empty HyperLedger network for further experiments or software development.

Note that this basic network is built from a network template which may not be exact as what you need.

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

To build cryptography keys and network definitions, run ``build.sh``.

To remove cryptography keys and network definitions, run ``clean.sh``.

To start the network, run ``start.sh``.

To stop it, run ``stop.sh``.

To restart the network, run ``restart.sh``.

## Amazon EC2 instance requirements
The HyperLedger network requires quite a lot of memory and disk size.
We recommend having:
- at least 8GB of memory;
- at least 60GB of free disk space.

The following instance type can be used:
- m1.xlarge.

## License agreement

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
TODO: