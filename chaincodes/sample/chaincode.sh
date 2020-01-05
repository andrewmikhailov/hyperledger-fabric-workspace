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
esac
