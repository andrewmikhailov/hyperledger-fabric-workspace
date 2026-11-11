package main

import (
	"encoding/json"
	"os"
	"strings"
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

// Init must always acknowledge success.
func TestInitReturnsSuccess(t *testing.T) {
	if resp := new(Shell).Init(shim.NewMockStub("", nil)); resp.Status != 200 {
		t.Fatalf("Init status = %d, want 200", resp.Status)
	}
}

// Invoke runs the command through ./eval.sh and returns its stdout/stderr
// as a JSON document which is also persisted to the ledger state.
func TestInvokeExecutesCommandAndPersistsResult(t *testing.T) {
	stub := shim.NewMockStub("exec", []string{"echo hello-from-unit-test"})
	resp := new(Shell).Invoke(stub)
	if resp.Status != 200 {
		t.Fatalf("Invoke status = %d, want 200, payload %q", resp.Status, resp.Payload)
	}

	var payload map[string]string
	if err := json.Unmarshal(resp.Payload, &payload); err != nil {
		t.Fatalf("payload is not valid JSON: %v", err)
	}
	if payload["command"] != "echo hello-from-unit-test" {
		t.Errorf("payload[command] = %q, want %q", payload["command"], "echo hello-from-unit-test")
	}
	if !strings.Contains(payload["output"], "hello-from-unit-test") {
		t.Errorf("payload[output] = %q, want it to contain the command output", payload["output"])
	}

	if len(stub.State) != 1 {
		t.Fatalf("ledger state has %d entries, want 1", len(stub.State))
	}
	for _, stored := range stub.State {
		if string(stored) != string(resp.Payload) {
			t.Errorf("stored state = %q, want %q", stored, resp.Payload)
		}
	}
}

// A stderr-producing command must be reported under the "error" key.
func TestInvokeCapturesStderr(t *testing.T) {
	stub := shim.NewMockStub("exec", []string{"echo oops >&2"})
	resp := new(Shell).Invoke(stub)
	if resp.Status != 200 {
		t.Fatalf("Invoke status = %d, want 200, payload %q", resp.Status, resp.Payload)
	}
	var payload map[string]string
	if err := json.Unmarshal(resp.Payload, &payload); err != nil {
		t.Fatalf("payload is not valid JSON: %v", err)
	}
	if !strings.Contains(payload["error"], "oops") {
		t.Errorf("payload[error] = %q, want it to contain the command stderr", payload["error"])
	}
}

// When ./eval.sh is missing next to the agent, the command cannot run and
// Invoke must degrade to a shim error instead of panicking.
func TestInvokeWithoutEvalScriptReturnsError(t *testing.T) {
	dir, err := os.MkdirTemp("", "shelleval")
	if err != nil {
		t.Fatal(err)
	}
	defer os.RemoveAll(dir)

	old, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(dir); err != nil {
		t.Fatal(err)
	}
	defer os.Chdir(old)

	resp := new(Shell).Invoke(shim.NewMockStub("exec", []string{"echo nope"}))
	if resp.Status != 500 {
		t.Errorf("Invoke status = %d, want 500", resp.Status)
	}
}
