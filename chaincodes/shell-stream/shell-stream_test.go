package main

import (
	"io"
	"net"
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

// Init must always acknowledge success.
func TestInitReturnsSuccess(t *testing.T) {
	if resp := new(SSHStream).Init(shim.NewMockStub("", nil)); resp.Status != 200 {
		t.Fatalf("Init status = %d, want 200", resp.Status)
	}
}

// Any function other than "eval" is reported back as unknown.
func TestInvokeUnknownFunction(t *testing.T) {
	resp := new(SSHStream).Invoke(shim.NewMockStub("whatever", []string{"a"}))
	if resp.Status != 200 {
		t.Fatalf("Invoke status = %d, want 200", resp.Status)
	}
	if string(resp.Payload) != "ERROR_UNKNOWN" {
		t.Errorf("Invoke payload = %q, want %q", resp.Payload, "ERROR_UNKNOWN")
	}
}

// "eval" writes the command to the tunnel FIFO endpoint and returns the
// reply read back from it, with the ":)" terminator stripped.
func TestInvokeEvalReadsTunnelResponse(t *testing.T) {
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()

	go func() {
		for {
			connection, err := listener.Accept()
			if err != nil {
				return
			}
			io.WriteString(connection, "tunnel-output:)")
			connection.Close()
		}
	}()

	stub := shim.NewMockStub("eval", []string{listener.Addr().String(), "hostname"})
	resp := new(SSHStream).Invoke(stub)
	if resp.Status != 200 {
		t.Fatalf("Invoke status = %d, want 200, payload %q", resp.Status, resp.Payload)
	}
	if string(resp.Payload) != "tunnel-output" {
		t.Errorf("Invoke payload = %q, want %q", resp.Payload, "tunnel-output")
	}
}
