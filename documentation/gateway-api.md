# HyperLedger chain-code gateway API
## /chainCode/invoke
HTTP POST API end-point. 

Invokes an operation on a chain-code which is running on a peer.
- MSP identifier maps into the folder containing certificates.
- Administrator credentials to authenticate into the certificate authority.
- Chain-code identifier (name) for the installed chaincode which should be invoked.
- Function to be invoked (not supported yet).
- Parameters for the function which is invoked.

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
    "identifier": "fdc1d28faad74cf7b31c6f4c09f01daa"
  },
  "parameters": [
    "ls"
  ]
}
```
### Response
As a result:
- A string containing whatever was returned by the chain-code function.
