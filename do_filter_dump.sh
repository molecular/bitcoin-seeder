#!/bin/bash
cd $(dirname $0)
source ./config.sh
tail -n +2 dnsseed.dump | ./filter_dump.sh > ipv4_nodes.dat && \
scp ipv4_nodes.dat $SCP_DEST

