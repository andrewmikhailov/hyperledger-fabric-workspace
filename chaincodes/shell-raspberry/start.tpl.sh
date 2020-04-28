#!/bin/sh
### BEGIN INIT INFO
# Provides:          HyperShell agent
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       HyperShell agent
### END INIT INFO

# Settings
BINARY_NAME=shell-raspberry
CHAINCODE_ID_NAME={CHAINCODE_ID_NAME}
CHAINCODE_VERSION={CHAINCODE_VERSION}
PEER_ADDRESS={PEER_ADDRESS}

# Methods
start() {
  CORE_PEER_ADDRESS=$PEER_ADDRESS CORE_CHAINCODE_ID_NAME=$CHAINCODE_ID_NAME:$CHAINCODE_VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug ./$BINARY_NAME
}

case "$1" in
  start)
    start
    ;;
  *)
    echo "Usage: $0 {start}"
esac
