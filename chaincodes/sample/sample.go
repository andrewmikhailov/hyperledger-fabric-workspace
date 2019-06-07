package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type Sample struct {
}

func (t *Sample) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *Sample) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, _ := stub.GetFunctionAndParameters()
	return shim.Success([]byte(function))
}

func main() {
	if error := shim.Start(new(Sample)); error != nil {
		fmt.Printf("Error starting 'Sample' chaincode: %s", error)
	}
}