VERSION=1
case $1 in
	install)
		NODE_NAME="$(od -x /dev/urandom | head -1 | awk '{OFS=""; print $2$3,$4,$5,$6,$7$8$9}')"
		peer chaincode install -p github.com/chaincodes/shell -n $NODE_NAME -v $VERSION
		# TODO: In the multiple OS environment, need to separate instantiation and installation
		peer chaincode instantiate -n $NODE_NAME -v $VERSION -c '{"Args":[]}' -C channel
		echo "{name: \"$NODE_NAME\"}"
		;;
	upgrade)
		peer chaincode install -p github.com/chaincodes/shell -n $2 -v $VERSION
		peer chaincode upgrade -p github.com/chaincodes/shell -n $2 -v $VERSION -c '{"Args":[]}' -C channel
		;;
	invoke)
		peer chaincode invoke -n $2 -c '{"Args":["eval", "ls"]}' -C channel
		;;
	shell)
		peer chaincode invoke -n $2 -c '{"Args":["eval", "'$3'"]}' -C channel
		;;
esac
