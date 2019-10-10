package main

import (
	"fmt"
	"net"
	"time"
	"bufio"
	"strings"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	// "github.com/hyperledger/fabric/core/chaincode/lib/cid"
	"github.com/hyperledger/fabric/protos/peer"
)

type SSHStream struct {
}

func (t *SSHStream) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *SSHStream) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	// id, _ := cid.GetID(stub)

	messageSuffix := ":)"

	function, arguments := stub.GetFunctionAndParameters()
	if "eval" == function {

		tunnelUri := arguments[0]
		command := arguments[1]

		fmt.Printf("SHELL command:\n%s\n", command)
		fmt.Printf("On tunnel:\n%s\n", tunnelUri)

		// Execute the desired SHELL command
		connection, error := net.Dial("tcp", tunnelUri)
		fmt.Fprintf(connection, command)
		time.Sleep(1 * time.Second)
		connection.Close()
		time.Sleep(1 * time.Second)

		// Read the SHELL response
		content := ""
		connection, error = net.Dial("tcp", tunnelUri)
		if nil == error {
			reader := bufio.NewReader(connection)
			error = nil
			for nil == error && !strings.HasSuffix(content, messageSuffix) {
				atom := make([]byte, 1)
				_, error = reader.Read(atom)
				content += string(atom)
			}
		}

		fmt.Printf("SHELL response:\n%s", content)

		response := strings.TrimSuffix(content, messageSuffix)
		return shim.Success([]byte(response))
	}

	return shim.Success([]byte("ERROR_UNKNOWN"))
}

func main() {

	if error := shim.Start(new(SSHStream)); error != nil {
		fmt.Printf("Error starting 'SSHStream' chaincode: %s", error)
	}
}
