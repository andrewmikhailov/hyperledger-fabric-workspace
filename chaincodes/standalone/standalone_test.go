package main

import (
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

// Init must always acknowledge success.
func TestInitReturnsSuccess(t *testing.T) {
	if resp := new(Standalone).Init(shim.NewMockStub("", nil)); resp.Status != 200 {
		t.Fatalf("Init status = %d, want 200", resp.Status)
	}
}

// Invoke echoes back the requested function name as its payload.
func TestInvokeEchoesFunctionName(t *testing.T) {
	for _, fn := range []string{"ping", "status", "anything"} {
		resp := new(Standalone).Invoke(shim.NewMockStub(fn, []string{"a", "b"}))
		if resp.Status != 200 {
			t.Errorf("Invoke(%q) status = %d, want 200", fn, resp.Status)
		}
		if string(resp.Payload) != fn {
			t.Errorf("Invoke(%q) payload = %q, want %q", fn, resp.Payload, fn)
		}
	}
}
