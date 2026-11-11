package peer

// Response is a minimal test double of the Fabric peer.Response type.
type Response struct {
	Status  int32
	Payload []byte
}
