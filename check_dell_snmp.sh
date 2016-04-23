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
SYSTEMSTATUS=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.2.1 | awk -F : '{print $2}'`
RAIDBATTERY=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.130.15.1.6 | awk -F : '{print $2}'`
FAN=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.4.700.10.1.8 | awk -F : '{print $2}'`
CPU=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.4.1100.30.1.5 | awk -F : '{print $2}'`
PHYSICALDISKS=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.24 | awk -F : '{print $2}'`

VIRTUALDISKS=`snmpwalk -v 2c -c public $1 .1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.4 | awk -F : '{print $2}'`
VIRTUALDISKS1=`echo $VIRTUALDISKS | awk '{print $1}'`
VIRTUALDISKS2=`echo $VIRTUALDISKS | awk '{print $2}'`

echo 'System status :'$SYSTEMSTATUS
echo 'RAID Battery : '$RAIDBATTERY
echo 'FAN : '$FAN
echo 'CPU : '$CPU
echo 'Physical Disks : '$PHYSICALDISKS
echo 'Virtual Disks : '$VIRTUALDISKS
echo 'Virtual Disk n°1 :'$VIRTUALDISKS1
echo 'Virtual Disk n°2 : '$VIRTUALDISKS2




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
        exit $STATE_UNKNOWN
fi

