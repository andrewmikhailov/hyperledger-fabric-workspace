package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type Standalone struct {
}

func (t *Standalone) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *Standalone) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, _ := stub.GetFunctionAndParameters()
	return shim.Success([]byte(function))
}

func main() {
	if error := shim.Start(new(Standalone)); error != nil {
		fmt.Printf("Error starting 'Standalone' chaincode: %s", error)
	}
}