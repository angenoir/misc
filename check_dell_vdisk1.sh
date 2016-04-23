#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i OK=3
declare -i VIRTUALUNKNOWN=1
declare -i VIRTUALOK=2

VIRTUALDISKS=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.4 | awk -F : '{print $2}'`
VIRTUALDISKS1=`echo $VIRTUALDISKS | awk '{print $1}'`

if [ "$VIRTUALDISKS1" == "$VIRTUALOK" ]
then
        echo "OK - Virtual Disk 1 is OK"
        exit $STATE_OK
elif [ "$VIRTUALDISKS1" == "$VIRTUALUNKNOWN" ]
        then
        echo "UNKNOWN - Virtual Disk 1 is UNKNOWN"
        exit $STATE_UNKNOWN
else
        echo "CRITICAL - Virtual Disk 1 is CRITICAL"
        exit $STATE_CRITICAL
fi
