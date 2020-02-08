#!/bin/bash

# Exit on first error, print all commands.
set -e

# Shut down the Docker containers for the system tests.
docker-compose -f docker-compose.yml kill && docker-compose -f docker-compose.yml down
docker-compose rm

# remove the local state
rm -f ~/.hfc-key-store/*
rm -rf config crypto-config
