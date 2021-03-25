# Fixing the timeout issue on Amazon machines
export DOCKER_CLIENT_TIMEOUT=420
export COMPOSE_HTTP_TIMEOUT=420

./stop.sh
./clean.sh
./build.sh
./create.sh
./start.sh
