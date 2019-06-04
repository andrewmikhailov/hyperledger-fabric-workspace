# Fixing the timeout issue on Amazon machines
export DOCKER_CLIENT_TIMEOUT=420
export COMPOSE_HTTP_TIMEOUT=420

# Fixing the permission problem while accessing Docker IPC
chmod 777 /var/run/docker.sock

./stop.sh
./start.sh


