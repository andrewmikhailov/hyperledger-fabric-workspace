#!/bin/bash
set -ev

startHostShellTunnel() {

	echo "Starting Docker host shell tunnel"

	USER=ubuntu
	INPUT_FIFO=/tmp/docker-host-shell-tunnel-input.fifo 
	OUTPUT_FIFO=/tmp/docker-host-shell-tunnel-output.fifo

	# Clean-up previous FIFO worker data
	if [[ -f "$INPUT_FIFO" ]]; then
		rm $INPUT_FIFO
	fi

	if [[ -f "$OUTPUT_FIFO" ]]; then
		rm $OUTPUT_FIFO
	fi

	# Start the FIFO worker to process incoming command requests
	touch $INPUT_FIFO $OUTPUT_FIFO
	chown $USER $INPUT_FIFO $OUTPUT_FIFO
	./worker.sh $INPUT_FIFO $OUTPUT_FIFO &
}

startHostShellTunnel
