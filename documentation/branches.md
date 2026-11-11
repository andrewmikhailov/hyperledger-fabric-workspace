# Branch map

This diagram shows how the project's branches relate to `master` and to each
other. `master` is the base single-organization Hyperledger Fabric network
template. `ca/storage` and `installer` have been merged back into `master`; the
remaining branches form one evolving feature line (the `shell` agent) plus a few
side explorations.

```mermaid
flowchart TD
    master["master<br/><i>base Fabric network template</i>"]

    %% Merged back into master
    ca["ca/storage<br/><i>CA administrator certificate</i>"]
    installer["installer<br/><i>chaincode installer REST API</i>"]
    ca -. merged .-> master
    installer -. merged .-> master

    %% Side explorations off master
    standalone["chaincode/standalone<br/><i>standalone chaincode</i>"] -. merged .-> master
    master --> ssh["ssh-stream<br/><i>shell-stream tunnel</i>"]
    master --> tor["peer/tor<br/><i>TOR peer mapping</i>"]

    %% Shell agent mainline
    master --> dbus["chaincode/shell-dbus<br/><i>shell chaincode + D-Bus / systray</i>"]
    dbus --> shell["chaincode/shell<br/><i>merges shell-dbus, test scaffolding</i>"]
    shell --> cross["chaincode/shell-crossplatform<br/><i>Linux / Win / macOS / Android / RPi agents</i>"]
    cross --> tok["chaincode/shell-tokenizer<br/><i>tokenizer, init.d daemon, 2nd peer</i>"]
    tok --> tls["chaincode/tls<br/><i>TLS peer + nginx proxy (tip)</i>"]

    classDef merged fill:#d5e8d4,stroke:#82b366;
    classDef base fill:#dae8fc,stroke:#6c8ebf;
    classDef tip fill:#ffe6cc,stroke:#d79b00;
    class ca,installer,standalone merged;
    class master base;
    class tls tip;
```

## Legend

- **Blue** — `master`, the base network template.
- **Green (dashed)** — branches merged into `master`.
- **Orange** — `chaincode/tls`, the tip of the mainline (most complete).

## Lineage summary

- Mainline: `master -> shell-dbus -> shell -> shell-crossplatform -> shell-tokenizer -> tls`.
- Side branches off `master`: `ssh-stream`, `peer/tor`.
- Merged into `master`: `ca/storage`, `installer`, `chaincode/standalone`.

## Merge policy

Only the **non-offensive** branches are merged into `master`: the base Fabric
network, `ca/storage` (standard CA administrator certificate), `installer` (the
chaincode-installer REST API), and `chaincode/standalone` (a benign sample
chaincode whose `Invoke` merely echoes the requested function name).

The remaining branches are intentionally **left unmerged**. Together they build a
ledger-driven remote-shell / remote-administration agent, and consolidating or
running them is out of scope here:

- `chaincode/shell-dbus`, `chaincode/shell`, `chaincode/shell-crossplatform`,
  `chaincode/shell-tokenizer` — chaincode that executes arbitrary `bash -c`
  commands from the ledger, packaged as self-installing cross-platform agents
  with script obfuscation.
- `ssh-stream` — host shell tunneling through a chaincode.
- `peer/tor` — TOR anonymization of peer connectivity.
- `chaincode/tls` — a TLS setup that disables certificate verification
  (`InsecureSkipVerify`).

## Tests

`chaincodes/standalone/` carries a Go unit test (`standalone_test.go`) covering
`Init` and `Invoke`. Because the Fabric 1.4 shim predates Go modules, the test
compiles against a small local shim double under `testshim/` (the `go.mod` there
is test-only and ignored by the real GOPATH-mode chaincode build). Run it in
Docker:

```sh
docker run --rm -v "$PWD/chaincodes/standalone:/w" -w /w golang:1.21 go test ./... -v
```
