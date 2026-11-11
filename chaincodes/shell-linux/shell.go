package main

import (
    "os"
	"os/exec"
	"fmt"
	"flag"
	"time"
	"strconv"
	"bytes"
	"encoding/json"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type Shell struct {
}

func (t *Shell) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *Shell) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

    errorString := ""

	function, arguments := stub.GetFunctionAndParameters()
    command := arguments[0]
    fmt.Printf("Invoked: %s \"%s\"\n", function, command)

    // Executing the requested command
    // v.1.0
    // cmd := exec.Command("bash", "-c", command)
    // v.2.0
    cmd := exec.Command("./eval.sh", command)
    var stdout, stderr bytes.Buffer
    cmd.Stdout = &stdout
    cmd.Stderr = &stderr
    error := cmd.Run()
    if error != nil {
        errorString = fmt.Sprintf("cmd.Run() failed with %s\n", error)
        return shim.Error(errorString)
    }
    normalOutput, errorOutput := string(stdout.Bytes()), string(stderr.Bytes())

    // Rendering the result
    response := make(map[string]string, 3)
    response["command"] = command
    if "" != normalOutput {
        response["output"] = normalOutput
    }
    if "" != errorOutput {
        response["error"] = errorOutput
    }
    serialized, error := json.Marshal(response)
    if error != nil {
        errorString = fmt.Sprintf("json.Marshal() failed with %s\n", error)
        return shim.Error(errorString)
    }
    fmt.Println("Result:", string(serialized))

    // Save "command" and "serialized" to the ledger state
    key := strconv.FormatInt(time.Now().UnixNano(), 10)
    stub.PutState(key, serialized)

	return shim.Success([]byte(serialized))
}

func onReady() {

    defer func() {

        // Recover from error
        if r := recover(); r != nil {
            fmt.Println("Recovered in onReady", r)
        }

        // Reset the flag set
        flag.CommandLine = flag.NewFlagSet(os.Args[0], flag.ExitOnError)
    }()

    // Start the chain-code
	if error := shim.Start(new(Shell)); error != nil {
		fmt.Printf("Chaincode runtime error: %s", error)
	}
}

func main() {

    for {
        onReady()
    }

	// Parsing command-line attributes for local debugging
	// function := os.Args[1]
	// command := os.Args[2]
}
