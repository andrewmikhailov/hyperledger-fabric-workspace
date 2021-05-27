#!/bin/sh
### BEGIN INIT INFO
# Provides:          HyperShell agent
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       HyperShell agent
### END INIT INFO

## Settings
FOLDER_NAME=$(dirname $(readlink -f "$0"))
BINARY_NAME="$FOLDER_NAME/shell-linux"
# Whether the environment variable is not defined
if test -z "$CHAINCODE_ID_NAME"
then
  CHAINCODE_ID_NAME={CHAINCODE_ID_NAME}
fi
# Whether the environment variable is not defined
if test -z "$CHAINCODE_VERSION"
then
  CHAINCODE_VERSION={CHAINCODE_VERSION}
fi
# Whether the environment variable is not defined
if test -z "$PEER_ADDRESS"
then
  PEER_ADDRESS={PEER_ADDRESS}
fi
export TOKENIZER_ENDPOINT=http://softethica.com:3007/keyChain/password

# Methods
start() {
  # Set the current directory so that the agent is able to find scripts
  cd "$FOLDER_NAME" || exit
  CORE_PEER_ADDRESS=$PEER_ADDRESS CORE_CHAINCODE_ID_NAME=$CHAINCODE_ID_NAME:$CHAINCODE_VERSION CORE_CHAINCODE_LOGGING_LEVEL=debug $BINARY_NAME &
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
    chmod +x eval.sh
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
