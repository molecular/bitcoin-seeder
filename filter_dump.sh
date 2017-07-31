#!/bin/bash
source ./config.sh
if [[ "$FILTER_PORT" == "" ]]; then
	FILTER_PORT=8333;
fi

# prepare files in $OUT folder
mkdir -p $OUT
for i in 0 1 2; do > $OUT/$i.ipv4; > $OUT/$i.filtered.dump; done

# go through input linewise parsing variables
while IFS=' ' read -r host good lastSuccess p2h p8h p1d p7d p30d blocks svcs version subver || [[ -n "$host" ]]; do
	port=$(echo $host | cut -d : -f 2)
	host=$(echo $host | cut -d : -f 1)
	if [[ "$port" -eq "$FILTER_PORT" ]]; then
		if (((16#$svcs & 16#20) != 0)); then # service bit BITCOIN_CASH 1 << 5
			# decide which file slot to output to (for prioritization)
			if [[ "$good" -eq "1" ]]; then i=0;
				if [[ ! $subver =~ ^\/Bitcoin\ ABC:0.14.6.*$ ]]; then
					i=1;
				fi
			else 
				i=2; 
			fi
			echo "host=$host, i=$i"
			echo $host:$port $good $(date -d @$lastSuccess) $p2h $p8h $p1d $p7d $p30d $blocks $svcs $version $subver >> $OUT/$i.filtered.dump
			echo $host >> $OUT/$i.ipv4;
		fi
	fi
done 
