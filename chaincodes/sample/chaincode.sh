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
		CORE_PEER_ADDRESS=azfv7xfjsup6ghsy.onion:7052
		# CORE_PEER_ADDRESS=q5564trzm6yibazo.onion:7052
		CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS CORE_CHAINCODE_ID_NAME=sample:$VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug torsocks ./sample
		;;
esac
