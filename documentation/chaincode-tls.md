# Chain-code TLS configuration

## Environment variables for loading certificates
The following environment variables need to be specified for the chain-code to make it use the TLS encryption:
```shell
CORE_PEER_TLS_ROOTCERT_FILE=./ca.crt CORE_PEER_TLS_ENABLED=true CORE_TLS_CLIENT_CERT_PATH=./server.crt CORE_TLS_CLIENT_KEY_PATH=./server.key 
```

## Preparing certificates
For more fun, certificates are not in the standard format.

So, it is necessary to apply the "base64" encoding to normal certificate contents.

## Patching the "shim"
Furthermore, need to disable certificate chain check in the GRPC level of the "shim" library.
It can be done with the following patch:
```diff
diff --git a/core/comm/connection.go b/core/comm/connection.go
index b73898f24..d144295e7 100644
--- a/core/comm/connection.go
+++ b/core/comm/connection.go
@@ -258,6 +258,7 @@ func InitTLSForShim(key, certStr string) credentials.TransportCredentials {
                commLogger.Panicf("failed to append certificates")
        }
        return credentials.NewTLS(&tls.Config{
+           InsecureSkipVerify: true,
                Certificates: []tls.Certificate{cert},
                RootCAs:      cp,
                ServerName:   sn,

```
This patch is applicable for **HyperLedger Release 1.4** from https://github.com/hyperledger/fabric
