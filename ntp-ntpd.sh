#!/bin/bash

#################################################################################################################
#REQUIRES NTPDATE TO WORK AND YOU NEED TO SET PUBKEY AUTH ON THE DISTANT MACHINE AND SEND YOUR NAGIOS-BOX PUBKEY#
#RETURN THE ABSOLUTE VALUE OF THE OFFSET BETWEEN THE MACHINE AND NTP_SERVER_IP				      				#
#IF THE OFFSET IS SUPERIOR TO 300 seconds THE SCRIPT WILL RETURN A CRITICAL STATUS								#
#IF THE SERVER IS NOT FOUND THE SCRIPT WILL RETURN AN UNKNOWN VALUE												#
#OTHERWISE IT WILL RETURN AN OK STATUS																			#
#THE OUTPUT OF THE SCRIPT IS FULLY COMPATIBLE WITH PNP4NAGIOS METROLOGY											#
#																												#
#The nagios/shinken/icinga command definition is like the following :											#
#define command{																								#
#	command_name	check_ntp_linux																				#
#	command_line	ssh nagios@$HOSTADDRESS$ /home/nagios/ntp.sh												#
#}																												#
#################################################################################################################

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
OFFSET_MAX=300
STRATUS_MIN=0
NTP_SERVER_IP=0.0.0.0
RESULTAT=`ntpdate -q $NTP_SERVER_IP | head -n 1 | awk -F " " {'print $4$6'}`
STRATUS=`echo $RESULTAT | cut -d , -f 1 | sed 's/,/ /g'`
OFFSET=`echo $RESULTAT | cut -d , -f 2 | sed 's/-/ /g'`
OFFSET=`echo $OFFSET | sed 's/+/ /g'`
run() {
CMP_OFFSET=$(echo "$OFFSET >= $OFFSET_MAX" | bc -l)
if [ $STRATUS -eq $STRATUS_MIN ]
	then echo "CRITICAL - Could'nt reach NTP server";
	exit $STATE_CRITICAL
elif [ $CMP_OFFSET = 1 ]
	then echo "CRITICAL - Offset is > 300s"
	exit $STATE_CRITICAL
elif [ $STRATUS -gt $STRATUS_MIN ] && [ $CMP_OFFSET = 0 ]
	then
	echo "OK - Stratus : "$STRATUS" Offset : "$OFFSET"| Offset="$OFFSET"seconds"
	exit $STATE_OK
else
	echo "Unknown"
	exit $STATE_UNKNOWN
fi
}
test() {
	CMP_OFFSET=$(echo "$OFFSET >= $OFFSET_MAX" | bc -l)
	echo $CMP_OFFSET
	echo $RESULTAT
	echo $STRATUS
	echo $OFFSET
}
run
