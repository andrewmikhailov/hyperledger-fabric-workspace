package main

import (
	"os"
	"os/exec"
	"fmt"
	"bytes"
	"encoding/json"
	// "github.com/hyperledger/fabric/core/chaincode/shim"
	// "github.com/hyperledger/fabric/protos/peer"
)

type Shell struct {
}

/*
func (t *Shell) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *Shell) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, _ := stub.GetFunctionAndParameters()
	return shim.Success([]byte(function))
}
*/

func main() {

	/*
	if error := shim.Start(new(Shell)); error != nil {
		fmt.Printf("Error starting 'Shell' chaincode: %s", error)
	}
	*/

	// Parsing command-line attributes for local debugging
	function := os.Args[1]
	command := os.Args[2]
	fmt.Printf("Invoked: %s \"%s\"\n", function, command)

	// Executing the requested command
	cmd := exec.Command("bash", "-c", command)
    var stdout, stderr bytes.Buffer
    cmd.Stdout = &stdout
    cmd.Stderr = &stderr
    error := cmd.Run()
    if error != nil {
        fmt.Printf("cmd.Run() failed with %s\n", error)
        return
    }
    normalOutput, errorOutput := string(stdout.Bytes()), string(stderr.Bytes())

    // Rendering the result
    response := make(map[string]string, 2)
    if "" != normalOutput {
    	response["output"] = normalOutput
    }
    if "" != errorOutput {
    	response["error"] = errorOutput
    }
    serialized, error := json.Marshal(response)
    if error != nil {
        fmt.Printf("json.Marshal() failed with %s\n", error)
        return
    }
    fmt.Println("Result:", string(serialized))
}