#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

bc_data_free=`/PATH/TO/oracle_bcdata.sh | awk '/-------------------------/,/ SQL>/' | cut -d '-' -f1 | awk -F 'SQL>' '{print $1}'`
test=$( echo $bc_data_free | awk '{$1=$1}{ print }' | awk '{printf("%03.3f", $1);}')


if [ "1" -eq $( echo $bc_data_free "> 0.500" | bc ) ]
then
        echo "OK - BC_DATA is "$test"GB free |FREE="$test"GB;0.500;0.200;"
        exit $STATE_OK
elif [ "1" -eq $( echo $bc_data_free "< 0.200" | bc ) ]
        then
        echo "CRITICAL - BC_DATA is "$test"GB free |FREE="$test"GB;0.500;0.200;"
        exit $STATE_CRITICAL
elif [ "1" -eq $( echo $bc_data_free "< 0.500" | bc ) ]
        then
        echo "WARNING - BC_DATA is "$test"GB free |FREE="$test"GB;0.500;0.200;"
        exit $STATE_WARNING
else
        echo "UNKNOWN |Unknown state"
        exit $STATE_UNKNOWN
fi

