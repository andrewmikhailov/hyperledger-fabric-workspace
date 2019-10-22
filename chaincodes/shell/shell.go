package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type Shell struct {
}

func (t *Shell) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *Shell) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, _ := stub.GetFunctionAndParameters()
	return shim.Success([]byte(function))
}

func main() {
	if error := shim.Start(new(Shell)); error != nil {
		fmt.Printf("Error starting 'Shell' chaincode: %s", error)
	}
}