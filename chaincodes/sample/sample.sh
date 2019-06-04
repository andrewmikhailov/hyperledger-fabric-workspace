# CORE_PEER_ADDRESS=peer0.org1.example.com:7052 CORE_CHAINCODE_ID_NAME=sample:0 ./sample
peer chaincode install -p sample -n sample -v 0
peer chaincode instantiate -n sample -v 0 -c '{}' -C sample
