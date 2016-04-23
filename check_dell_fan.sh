#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i FANOK=3
declare -i FANUNKNOWN=2
declare -i FANWARNING=4
declare -i FANWARNING2=1

FAN=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.4.700.10.1.8 | awk -F : '{print $2}'`
FAN1=`echo $FAN | awk '{print $1}'`

if [ "$FAN1" == "$FANOK" ]
then
        echo "OK - FAN 1 is OK"
        exit $STATE_OK
else
        echo "CRITICAL - FAN 1 is CRITICAL"
        exit $STATE_CRITICAL
fi
