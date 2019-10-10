VERSION=1
NODE_NAME="$(od -x /dev/urandom | head -1 | awk '{OFS=""; print $2$3,$4,$5,$6,$7$8$9}')"
case $1 in
	install)
		echo $NODE_NAME
		peer chaincode install -p github.com/chaincodes/standalone -n $NODE_NAME -v $VERSION
		# peer chaincode instantiate -n standalone -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/standalone -n standalone -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/standalone -n standalone -v $VERSION -c '{"Args":[]}' -C mychannel
		;;
	invoke)
		peer chaincode invoke -n standalone -c '{"Args":["ping"]}' -C mychannel
		;;
esac
