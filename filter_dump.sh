#!/bin/bash
source ./config.sh
if [[ "$FILTER_PORT" == "" ]]; then
	FILTER_PORT=8333;
fi
echo "" > dnsseed.filtered.dump
while IFS=' ' read -r host good lastSuccess p2h p8h p1d p7d p30d blocks svcs version subver || [[ -n "$host" ]]; do
	port=$(echo $host | cut -d : -f 2)
	host=$(echo $host | cut -d : -f 1)
	if [[ "$port" -eq "$FILTER_PORT" ]]; then
		if (((16#$svcs & 16#20) != 0)); then # service bit BITCOIN_CASH 1 << 5
			echo $host:$port $good $lastSuccess $p2h $p8h $p1d $p7d $p30d $blocks $svcs $version $subver >> dnsseed.filtered.dump 
			echo $host
		fi
	fi
done 
