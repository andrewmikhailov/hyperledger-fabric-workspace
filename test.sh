case $1 in
	host-shell0)
		./tunnel.sh
		docker-compose -f docker-compose.yml up -d host-shell0.org1.example.com
		;;
	units)
		# Unit tests for every chaincode module against the local shim
		# double in chaincodes/testshim (Fabric 1.4 shim is not module
		# friendly, so the double replaces github.com/hyperledger/fabric).
		for module in standalone sample shell-linux shell-stream; do
			echo "=== go test ./... ($module) ==="
			docker run --rm -v "$PWD/chaincodes:/w" -w "/w/$module" golang:1.21 go test ./... -v
		done
		;;
esac
