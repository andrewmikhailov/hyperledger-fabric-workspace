// Test-only module. Fabric 1.4 peers build this chaincode in GOPATH mode
// (GO111MODULE off), so this file is ignored by the real chaincode build and
// only serves `go test`, which compiles against the shared ../testshim double.
module github.com/chaincodes/sample

go 1.21

require github.com/hyperledger/fabric v1.4.0

replace github.com/hyperledger/fabric => ../testshim
