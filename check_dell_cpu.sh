#!/bin/bash
#USAGE : 
#script.sh IDRAC_IP
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i CPUOK=3
declare -i CPUUNKNOWN=2
declare -i CPUWARNING=4
declare -i CPUWARNING2=1

CPU=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.4.1100.30.1.5 | awk -F : '{print $2}'`
CPU1=`echo $CPU | awk '{print $1}'`

if [ "$CPU1" == "$CPUOK" ]
then
        echo "OK - CPU 1 is OK"
        exit $STATE_OK
else
        echo "CRITICAL - CPU 1 is CRITICAL"
        exit $STATE_CRITICAL
fi
