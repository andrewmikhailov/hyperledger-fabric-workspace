case $1 in
	host-shell0)

		USER=ubuntu
		INPUT_FIFO=/tmp/docker-host-shell-tunnel-input.fifo 
		OUTPUT_FIFO=/tmp/docker-host-shell-tunnel-output.fifo

		# Clean-up previous FIFO worker data
		rm $INPUT_FIFO $OUTPUT_FIFO

		# Start the FIFO worker to process incoming command requests
		touch $INPUT_FIFO $OUTPUT_FIFO
		chown $USER $INPUT_FIFO $OUTPUT_FIFO
		./worker.sh $INPUT_FIFO $OUTPUT_FIFO &

		docker-compose -f docker-compose.yml up -d host-shell0.org1.example.com

		;;
esac
