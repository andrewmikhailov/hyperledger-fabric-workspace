#!/bin/sh

# Arguments
CA_USER=admin
CA_PASSWORD=adminpw
CA_HOST=ca.example.com:7054
USER=Administrator@org1.example.com
PASSWORD=$CA_PASSWORD

# Enroll CA user certificates
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" ca.example.com fabric-ca-client enroll -d -u http://$CA_USER:$CA_PASSWORD@$CA_HOST

# Register & enroll a new administrator
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" ca.example.com fabric-ca-client register -d --id.name $USER --id.secret $PASSWORD --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u http://$CA_USER:$CA_PASSWORD@$CA_HOST
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" -e "FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/users/$USER/msp" ca.example.com fabric-ca-client enroll -d -u http://$USER:$PASSWORD@$CA_HOST
docker exec -e "FABRIC_CA_CLIENT_TLS_CERTFILES=./ca-cert.pem" -e "FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/users/$USER/msp" ca.example.com fabric-ca-client certificate list --id $USER --store /etc/hyperledger/users/$USER/msp/admincerts
