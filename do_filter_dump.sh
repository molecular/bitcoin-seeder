#!/bin/bash
source ./config.sh
if [[ "$DIR" == "" ]]; then
	DIR=$(pwd);
fi
cd $DIR
tail -n +2 dnsseed.dump | ./filter_dump.sh > ipv4_nodes.dat && \
scp ipv4_nodes.dat $SCP_DEST

