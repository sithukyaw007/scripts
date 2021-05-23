#!/bin/bash
## To Collect CPU, Memory and Disk usage report from multiple servers
# Author: Sithu Kyaw
# Website: github.com/sithukyaw007
## format: Hostname, Date&Time, CPU%, Mem%, Disk%

HOSTNAME=$(hostname)
DATE=$(date "+%Y-%m-%d %H:%M:%S")
CPUSAGE=$(top -b -n 1 -d1 | grep "Cpu(s)" | awk '{print $2}' | awk -F. '{print $1}')
MEMUSAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISKUSAGE=$(df -P | column -t | awk '{print $5}' | tail -n 1 ) # sed 's/%//g' <-- this will replace % sign of disk usage

echo "HostName, Date&Time, CPUi(%), Mem(%), Disk(%)" >> ~/scripts/opt/usagereport
echo "=================================================" >> ~/scripts/opt/usagereport
echo "$HOSTNAME, $DATE, $CPUSAGE, $MEMUSAGE, $DISKUSAGE" >> ~/scripts/opt/usagereport

## The below is for running across multiple host

for i in `cat ~/scripts/hostlist`;
do
USERNAME="<user_name>"
RHOSTNAME=$(ssh $USERNAME@$i hostname)
echo "HOSTNAME is $i"
RDATE=$(ssh $USERNAME@$i 'date "+%Y-%m-%d %H:%M:%S"')
RCPUSAGE=$(ssh $USERNAME@$i top -b -n 1 -d1 | grep "Cpu(s)" | awk '{print $2}' | awk -F. '{print $1}')
RMEMUSAGE=$(ssh $USERNAME@$i free | grep Mem | awk '{print $3/$2 * 100.0}')
RDISKUSAGE=$(ssh $USERNAME@$i df -P | column -t | awk '{print $5}' | tail -n 1 ) # sed 's/%//g' <-- this will replace % sign of disk usage

echo "$RHOSTNAME, $RDATE, $RCPUSAGE, $RMEMUSAGE, $RDISKUSAGE" >> ~/scripts/opt/usagereport
done

printf "\n" >> ~/scripts/opt/usagereport
