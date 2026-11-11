package shim

import pb "github.com/hyperledger/fabric/protos/peer"

// ChaincodeStubInterface models only the methods the chaincodes under test use.
type ChaincodeStubInterface interface {
	GetFunctionAndParameters() (string, []string)
	PutState(key string, value []byte) error
}

type Chaincode interface {
	Init(ChaincodeStubInterface) pb.Response
	Invoke(ChaincodeStubInterface) pb.Response
}

func Success(payload []byte) pb.Response { return pb.Response{Status: 200, Payload: payload} }
func Error(msg string) pb.Response       { return pb.Response{Status: 500, Payload: []byte(msg)} }
func Start(cc Chaincode) error           { return nil }

// MockStub is a tiny stand-in for shimtest.MockStub.
type MockStub struct {
	function string
	args     []string
	State    map[string][]byte
}

func NewMockStub(function string, args []string) *MockStub {
	return &MockStub{function: function, args: args, State: map[string][]byte{}}
}

func (m *MockStub) GetFunctionAndParameters() (string, []string) { return m.function, m.args }
func (m *MockStub) PutState(key string, value []byte) error {
	m.State[key] = value
	return nil
}
