VERSION=1
case $1 in
	install)
		peer chaincode install -p github.com/chaincodes/standalone -n standalone -v $VERSION
		peer chaincode instantiate -n standalone -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/standalone -n standalone -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/standalone -n standalone -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	invoke)
		peer chaincode invoke -n standalone -c '{"Args":["ping"]}' -C mychannel
		;;
esac
