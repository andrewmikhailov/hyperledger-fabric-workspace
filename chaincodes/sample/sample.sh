peer chaincode install -p github.com/chaincodes/sample/sample -n sample -v 0
peer chaincode instantiate -n sample -v 0 -c '{"Args":[]}' -C mychannel
