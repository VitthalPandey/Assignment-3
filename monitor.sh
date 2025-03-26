#!/bin/bash

THRESHOLD=75

CPU_LOAD=$(top -bn5 -d 1 | grep "Cpu(s)" | awk '{sum += (100 - $8)} END {print sum/5}')

echo "$(date) - CPU Usage: $CPU_LOAD%" >> /var/log/monitor.log

if (( $(echo "$CPU_LOAD > $THRESHOLD" | bc -l) )); then
	echo "High CPU usage detected: $CPU_LOAD%" >> /var/log/monitor.log
	/bin/bash /opt/autoscale.sh
fi
