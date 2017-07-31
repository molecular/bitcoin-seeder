#!/bin/bash
cd $(dirname $0)
source ./config.sh

# feed into filter scripts
tail -n +2 dnsseed.dump | ./filter_dump.sh || exit 0

# prep / clear output files
> ipv4_nodes.dat
head -n 1 dnsseed.dump > dnsseed.filtered.dump

# concatenate files from $OUT folder
for i in 0 1 2; do
	cat $OUT/$i.ipv4 >> ipv4_nodes.dat
	cat $OUT/$i.filtered.dump >> dnsseed.filtered.dump
done 

# truncate to MAX_NODES
mv ipv4_nodes.dat ipv4_nodes.full.dat
head -n $MAX_NODES ipv4_nodes.full.dat > ipv4_nodes.dat

# copy to dns server
scp ipv4_nodes.dat $SCP_DEST
