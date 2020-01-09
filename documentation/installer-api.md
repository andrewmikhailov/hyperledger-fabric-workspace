# HyperLedger chain-code installer API
## /chainCode/install
HTTP POST API end-point. 

Installs and packages a chain-code using the MSP files on the server file-system, 
using administrator credentials and chain-code definition taken from the server file-system. 

MSP identifier maps into the folder containing certificates.

Chain-code name maps into the folder containing the chain-code definition.

Chain-code identifier argument is ignored.

Chain-code version should be increased while updating a chain-code with the given identifier.

### Request headers
Nest.js requires the content type header to be set to properly recognize POST requests.
```json
Content-Type: application/json
```
### POST Request
```json
{
  "msp": {
    "identifier": "Org1MSP"
  },
  "administrator": {
    "logOn": "Admin@org1.example.com",
    "password": "adminpw"
  },
  "chainCode": {
    "name": "sample",
    "identifier": "b62b3cb05bbb4d2ab27bb1e67137ea3b",
    "version": "1"
  }
}
```
```shell
curl -X POST -H 'Content-Type: application/json' -i http://localhost:3001/chainCode/install --data '{
  "msp": {
    "identifier": "Org1MSP"
  },
  "administrator": {
    "logOn": "Admin@org1.example.com",
    "password": "adminpw"
  },
  "chainCode": {
    "name": "sample",
    "identifier": "b62b3cb05bbb4d2ab27bb1e67137ea3b",
    "version": "1"
  }
}'
```
### Response
As a result:
- a new chain-code identifier (name) is generated;
- a ZIP-file containing the chain-code is generated;
- this ZIP-file becomes available for download through the "package" method.
```json
{
  "chainCode": {
    "identifier": "c89bc6c0652f4bb09cdc625b5ce1f232"
  }
}
```
## /chainCode/package
HTTP GET API end-point.

Downloads a ZIP-file containing the chain-code installer previously built.
### GET Request
```json
/chainCode/package/c89bc6c0652f4bb09cdc625b5ce1f232
```
```shell
curl -X GET -i http://localhost:3001/chainCode/package/c89bc6c0652f4bb09cdc625b5ce1f232
```
### Response
Binary file download when the chain-code package ZIP-file exists.
