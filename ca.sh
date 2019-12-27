#!/bin/sh

# Arguments
CA_USER=admin
CA_PASSWORD=adminpw
CA_HOST=ca.example.com:7054
USER=Admin@org1.example.com
PASSWORD=$CA_PASSWORD

# Enroll CA user certificates
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" ca.example.com fabric-ca-client enroll -d -u http://$CA_USER:$CA_PASSWORD@$CA_HOST

# Register & enroll a new administrator
docker exec ca.example.com rm -rf /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" ca.example.com fabric-ca-client register -d --id.name $USER --id.secret $PASSWORD --id.type admin --id.attrs '"hf.Registrar.Roles=admin"' -u http://$CA_HOST
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" -e "FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp" ca.example.com fabric-ca-client enroll -d -u http://$USER:$PASSWORD@$CA_HOST

# Copy new administrator's certificates to MSP folders over the whole peer organization
docker exec ca.example.com mkdir /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp/admincerts
docker exec ca.example.com cp /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp/signcerts/cert.pem /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp/admincerts/$USER-cert.pem
docker exec ca.example.com cp /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp/signcerts/cert.pem /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/msp/admincerts/$USER-cert.pem
docker exec ca.example.com cp /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/$USER/msp/signcerts/cert.pem /etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/admincerts/$USER-cert.pem
