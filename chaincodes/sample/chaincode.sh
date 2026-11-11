VERSION=4
case $1 in
	install)
		peer chaincode install -p github.com/chaincodes/sample -n sample -v $VERSION
		peer chaincode instantiate -n sample -v $VERSION -c '{"Args":[]}' -C channel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/sample -n sample -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/sample -n sample -v $VERSION -c '{"Args":[]}' -C channel
		;;
	invoke)
		peer chaincode invoke -n sample -c '{"Args":["ping"]}' -C channel
		;;
	test)
	  FROM_HOST=127.0.0.1 FROM_PORT=17052 PROXY_HOST=34.239.11.167 PROXY_PORT=9050 SERVER_HOST=nwwkakvfzjpdf536.onion SERVER_PORT=7052 proxy-tcp-tunnel &
		# CORE_PEER_ADDRESS=127.0.0.1:7052
		# CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS CORE_CHAINCODE_ID_NAME=sample:$VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug ./sample
		CORE_PEER_ADDRESS=127.0.0.1:17052
		CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS CORE_CHAINCODE_ID_NAME=sample:$VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug ./sample
		;;
esac
