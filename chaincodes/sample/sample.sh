VERSION=3
case $1 in
	install)
		peer chaincode install -p github.com/chaincodes/sample -n sample -v $VERSION
		peer chaincode instantiate -n sample -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/sample -n sample -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/sample -n sample -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	invoke)
		;;
esac
