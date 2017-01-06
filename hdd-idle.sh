#!/bin/bash
#idea taken from http://www.botcyb.org/2009/04/making-inactve-usb-hard-disk-spin-down.html
PATH=$PATH:/usr/bin:/bin
UUID=$1
PAUSE="0.1s"
TIMES=100
if [ -n "$UUID" ]; then
DISKNAME=`ls -l /dev/disk/by-uuid/ | grep "$UUID" | mawk '{ print $(NF) }' | sed s_\.\.\/\.\.\/__`
let a=0
#check $TIMES times with $GAP gaps,
#and go on adding
for i in `seq 0 $TIMES`
do
let a=`cat /proc/diskstats | grep $DISKNAME | mawk '{ print $(NF-2) }'`+a
sleep $PAUSE
done
echo $a
if [ $a == 0 ]
then
echo "No Activity"
/usr/bin/sdparm -C stop /dev/$DISKNAME
else
echo "Disk Active"
fi
else
	echo "Usage: $0 partition-uuid"
fi
exit 0
