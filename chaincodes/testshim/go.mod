// Test-only module. Fabric 1.4 peers build these chaincodes in GOPATH mode
// (GO111MODULE off), so this file is ignored by the real chaincode build and
// only serves `go test`, which compiles against this local shim double.
module github.com/hyperledger/fabric

go 1.21
