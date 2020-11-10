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
  download)
    wget -O agent.zip "$INSTALLER_URI/chainCode/package/$AGENT_IDENTIFIER"
    unzip agent.zip
    rm agent.zip
    cd "$AGENT_NAME" || exit
    chmod +x start.sh
    # TODO: This is a patch to fix improper configuration. Must be removed.
    # sed -i -- 's/peer0.org1.example.com/92.119.223.177/g' start.sh
    # TODO: This is a patch to fix improper configuration. Must be removed.
    # wget -O eval.sh https://raw.githubusercontent.com/andrewmikhailov/hyperledger-fabric-workspace/chaincode/shell-tokenizer/chaincodes/shell-linux/eval.sh
    chmod +x eval.sh
    # TODO: This is a patch to fix improper configuration. Must be removed.
    # wget -O tokenizer https://github.com/andrewmikhailov/hyperledger-fabric-workspace/raw/chaincode/shell-tokenizer/chaincodes/shell-linux/tokenizer
    chmod +x tokenizer
    cd ..
    mv "$AGENT_NAME" "$AGENT_NAME.tmp"
    cd "$AGENT_NAME.tmp" || exit
    cp * ../
    cd ..
    rm -rf "$AGENT_NAME.tmp"
    ;;
  start)
    start
    ;;
  install)
    install
    ;;
  *)
    echo "Usage: $0 {start|install|download}"
    ;;
esac
