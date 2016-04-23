#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i RAIDBATTERYOK=3
declare -i RAIDBATTERYUNKNOWN=2
declare -i RAIDBATTERYWARNING=4
declare -i RAIDBATTERYWARNING2=1

RAIDBATTERY=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.130.15.1.6 | awk -F : '{print $2}'`
RAIDBATTERY1=`echo $RAIDBATTERY | awk '{print $1}'`

if [ "$RAIDBATTERY1" == "$RAIDBATTERYOK" ]
then
        echo "OK - RAID Battery is OK"
        exit $STATE_OK
elif [ "$RAIDBATTERY1" == "$RAIDBATTERYUNKNOWN" ]
        then
        echo "UNKNOWN - RAID Battery is UNKNOWN"
        exit $STATE_UNKNOWN
elif [ "$RAIDBATTERY1" == "$RAIDBATTERYWARNING" ] || [ "$RAIDBATTERY1" == "$RAIDBATTERYWARNING1" ]
        then
        echo "WARNING - RAID Battery is WARNING"
        exit $STATE_UNKNOWN
else
        echo "CRITICAL - RAID Battery is CRITICAL"
        exit $STATE_CRITICAL
fi

