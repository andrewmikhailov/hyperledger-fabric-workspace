VERSION=1
case $1 in
	install)
		peer chaincode install -p github.com/chaincodes/ssh-stream -n ssh-stream -v $VERSION
		peer chaincode instantiate -n ssh-stream -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/ssh-stream -n ssh-stream -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/ssh-stream -n ssh-stream -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	invoke)
		peer chaincode invoke -n ssh-stream -c '{"Args":["ping"]}' -C mychannel
		;;
esac
