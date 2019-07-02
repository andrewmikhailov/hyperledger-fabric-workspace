package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/core/chaincode/lib/cid"
	"github.com/hyperledger/fabric/protos/peer"
)

type SSHStream struct {
}

func (t *SSHStream) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *SSHStream) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	id, _ := cid.GetID(stub)

	// function, _ := stub.GetFunctionAndParameters()
	return shim.Success([]byte(id))
}

func main() {
	if error := shim.Start(new(SSHStream)); error != nil {
		fmt.Printf("Error starting 'SSHStream' chaincode: %s", error)
	}
}