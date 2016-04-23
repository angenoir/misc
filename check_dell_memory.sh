#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i RAMOK=3
declare -i RAMUNKNOWN=2
declare -i RAMWARNING=4
declare -i RAMWARNING2=1

RAM=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.4.1100.50.1.5 | awk -F : '{print $2}'`
RAM1=`echo $RAM | awk '{print $1}'`

if [ "$RAM1" == "$RAMOK" ]
then
        echo "OK - RAM 1 is OK"
        exit $STATE_OK
else
        echo "CRITICAL - RAM 1 is CRITICAL"
        exit $STATE_CRITICAL
fi
