#!/bin/bash

[[ $1 ]] || echo "PID not set"
[[ $1 ]] && echo "PID set, so I will show usage of that PID and direct childs"
echo

echo "Core siblings: Cores printed on the same line are the same pyshical cores (and thus hyperthreading cores)"
cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | sort -u
echo 

while true
do
	# CPU usage for the PID or it's direct childs:
	ps -eo pcpu,psr,pid,ppid,args | awk -v somepid="$1" '{ if ( $3==somepid || $4==somepid )  print substr($0,0,100)  } '
	# Calculate usage per CPU core
	ps -eo pcpu,psr | awk '{ core[$2]=core[$2]+$1 } END { print "Core usage [%]: " core[0] "% " core[1]  "% " core[2] "% " core[3] "%" }'
	echo
	sleep 5
done

