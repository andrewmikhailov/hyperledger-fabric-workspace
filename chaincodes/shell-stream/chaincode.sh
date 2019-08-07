VERSION=1
case $1 in
	install)
		peer chaincode install -p github.com/chaincodes/shell-stream -n shell-stream -v $VERSION
		peer chaincode instantiate -n shell-stream -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/shell-stream -n shell-stream -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/shell-stream -n shell-stream -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	invoke)
		HOST_SHELL_TUNNEL_ADDRESS=localhost:1801
		# HOST_SHELL_TUNNEL_ADDRESS=host-shell0.org1.example.com:1801
		peer chaincode invoke -n shell-stream -c '{"Args":["eval", "'$HOST_SHELL_TUNNEL_ADDRESS'", "ls"]}' -C mychannel
		;;
	test)
		CORE_PEER_ADDRESS=localhost:7052
		# CORE_PEER_ADDRESS=peer0.org1.example.com:7052
		CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS CORE_CHAINCODE_ID_NAME=shell-stream:$VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug ./shell-stream 
		;;
esac
