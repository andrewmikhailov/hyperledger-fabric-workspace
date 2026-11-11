./tunnel.sh
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com peer1.org1.example.com couchdb installer gateway scheduler cli ide tls peer0.org1.example.onion host-shell0.org1.example.com
docker ps -a
