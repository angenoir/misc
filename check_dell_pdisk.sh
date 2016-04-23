#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i PHYSICALDISKSOK=3
declare -i PHYSICALDISKSUNKNOWN=2
declare -i PHYSICALDISKSWARNING=4
declare -i PHYSICALDISKSWARNING2=1

PHYSICALDISKS=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.24 | awk -F : '{print $2}'`
PHYSICALDISKS1=`echo $PHYSICALDISKS | awk '{print $1}'`

if [ "$PHYSICALDISKS1" == "$PHYSICALDISKSOK" ]
then
        echo "OK - Physical Disk 1 is OK"
        exit $STATE_OK
elif [ "$PHYSICALDISKS1" == "$PHYSICALDISKSUNKNOWN" ]
        then
        echo "UNKNOWN - Physical Disk 1 is UNKNOWN"
        exit $STATE_UNKNOWN
elif [ "$PHYSICALDISKS1" == "$PHYSICALDISKSWARNING" ] || [ "$PHYSICALDISKS1" == "$PHYSICALDISKSWARNING1" ]
        then
        echo "WARNING - Physical Disk 1 is WARNING"
        exit $STATE_UNKNOWN
else
        echo "CRITICAL - Physical Disk 1 is CRITICAL"
        exit $STATE_CRITICAL
fi
