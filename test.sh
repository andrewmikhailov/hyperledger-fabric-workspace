case $1 in
	host-shell0)
		./tunnel.sh
		docker-compose -f docker-compose.yml up -d host-shell0.org1.example.com
		;;
esac
