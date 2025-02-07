#!/usr/bin/env bash


# Usage: .simplescript.sh [LOGFILE_PATH]

echo "Starting simple script to write logs"
LOGFILE=$1
SECONDS_INTERVAL=5

while true
do	
	echo "Some Message" >> $LOGFILE
	echo "Logs being written to $LOGFILE every $SECONDS_INTERVAL seconds,Hit [CTRL+C] to stop! "
	sleep 5
done
