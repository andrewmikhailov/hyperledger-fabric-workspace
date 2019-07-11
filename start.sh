#!/bin/bash
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

startHostShellTunnel() {

	echo "Starting Docker host shell tunnel"

	USER=ubuntu
	INPUT_FIFO=/tmp/docker-host-shell-tunnel-input.fifo 
	OUTPUT_FIFO=/tmp/docker-host-shell-tunnel-output.fifo

	# Clean-up previous FIFO worker data
	if [[ -f "$INPUT_FIFO" ]]; then
		rm $INPUT_FIFO
	fi

	if [[ -f "$OUTPUT_FIFO" ]]; then
		rm $OUTPUT_FIFO
	fi

	# Start the FIFO worker to process incoming command requests
	touch $INPUT_FIFO $OUTPUT_FIFO
	chown $USER $INPUT_FIFO $OUTPUT_FIFO
	./worker.sh $INPUT_FIFO $OUTPUT_FIFO &
}

startHostShellTunnel
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb cli host-shell0.org1.example.com
docker ps -a

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block
