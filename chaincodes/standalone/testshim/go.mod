// Lightweight stand-in for the Fabric 1.4 shim, just enough to unit-test the
// chaincode offline. The real github.com/hyperledger/fabric v1.4 tree is not
// go-module friendly, so we model only the handful of symbols used here.
module github.com/hyperledger/fabric

go 1.21
