#!/bin/bash

#Requires esxcli utils
#Change the domain user and password from the DATEESX

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
declare -i WARNING_THRESHOLD=300
declare -i CRITICAL_THRESHOLD=300

run() {
DATEESX=`esxcli -s $SERVER -h $HOST -u 'DOMAIN\user' -p PASSWORD system time get`
DATE=`echo $DATEESX | awk -F 'T' '{print $1}'`
HOUR=`echo $DATEESX | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}'`
TIMESTAMPESX=`date -d ""$DATE" "$HOUR"" +%s`
LOCALEDATE=`date -u +%y-%m-%d`
LOCALETIME=`date -u +%T`
TIMESTAMPLOCAL=`date -d ""$LOCALEDATE" "$LOCALETIME"" +%s`
NTPDIFF=$(( $TIMESTAMPLOCAL - $TIMESTAMPESX ))
NTPDIFF=${NTPDIFF#-}

if [ $NTPDIFF -lt $WARNING_THRESHOLD ]
then
	echo ""$HOST"	NTP	"$STATE_OK"	Delta="$NTPDIFF"s |DELTA="$NTPDIFF"s;;;;"
        exit $STATE_OK
elif [ $NTPDIFF -gt $CRITICAL_THRESHOLD ]
        then
	echo ""$HOST"	NTP	"$STATE_CRITICAL"	Delta="$NTPDIFF"s |DELTA="$NTPDIFF"s;;;;"
        exit $STATE_CRITICAL
elif [ $NTPDIFF -eq $WARNING_THRESHOLD ]
        then
	echo ""$HOST"	NTP	"$STATE_WARNING"	Delta="$NTPDIFF"s |DELTA="$NTPDIFF"s;;;;"
        exit $STATE_WARNING
else
        echo ""$HOST"	NTP	"$STATE_UNKNOWN"	Unknown state |Unknown state"
        exit $STATE_UNKNOWN
fi
}

test() {

echo $HOST
echo $SERVER
echo $DATEESX
echo $DATE
echo $HOUR
echo $LOCALEDATE
echo $LOCALETIME
echo $TIMESTAMPLOCAL
echo $TIMESTAMPESX
echo $NTPDIFF

}

if [ ! $1 ]
        then run
fi

while [ $# -gt 0 ]; do
        case "$1" in
		-s | --server)
			shift
			SERVER=$1
			;;
                -H | --host)
                        shift
                        HOST=$1
                        ;;
                -w | --warning)
                        shift
                        WARNING_THRESHOLD=$1
                        ;;
                -c | --critical)
                        shift
                        CRITICAL_THRESHOLD=$1
                        ;;
        esac
shift
done

run
