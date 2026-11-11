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
    master --> standalone["chaincode/standalone<br/><i>standalone chaincode</i>"]
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
    class ca,installer merged;
    class master base;
    class tls tip;
```

## Legend

- **Blue** — `master`, the base network template.
- **Green (dashed)** — branches already merged into `master`.
- **Orange** — `chaincode/tls`, the tip of the mainline (most complete).

## Lineage summary

- Mainline: `master -> shell-dbus -> shell -> shell-crossplatform -> shell-tokenizer -> tls`.
- Side branches off `master`: `chaincode/standalone`, `ssh-stream`, `peer/tor`.
- Merged into `master`: `ca/storage`, `installer`.
