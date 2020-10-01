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
FOLDER_NAME=$(dirname $(readlink -f "$0"))
BINARY_NAME="$FOLDER_NAME/shell-linux"
CHAINCODE_ID_NAME={CHAINCODE_ID_NAME}
CHAINCODE_VERSION={CHAINCODE_VERSION}
PEER_ADDRESS={PEER_ADDRESS}
export TOKENIZER_ENDPOINT=http://softethica.com:3007/keyChain/password

# Methods
start() {
  CORE_PEER_ADDRESS=$PEER_ADDRESS CORE_CHAINCODE_ID_NAME=$CHAINCODE_ID_NAME:$CHAINCODE_VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug $BINARY_NAME
}
install() {
  link=/etc/init.d/hyshd
  if [ -f $link ] ; then
    rm $link
  fi
  ln -s "$FOLDER_NAME/start.sh" $link
  update-rc.d hyshd defaults
}

case "$1" in
  start)
    start
    ;;
  install)
    install
    ;;
  *)
    echo "Usage: $0 {start|install}"
    ;;
esac
