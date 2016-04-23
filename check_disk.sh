#!/bin/sh

## GLOBAL VARS
## -P option is for POSIX output for the Linux's version of df. Under SunOS 5.10 it's df -k. For HPUX it's -Pk

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
## Default values if none is set
declare -i WARNING_THRESHOLD=20
declare -i CRITICAL_THRESHOLD=10
declare DEVICE="/"

run() {
SHOW_ROOT=`df -Pk | grep ''$DEVICE'$' | awk '{print $5}'`
ROOT_FORMAT=`echo $SHOW_ROOT | cut -d % -f 1`
if [ $ROOT_FORMAT -gt $WARNING_THRESHOLD ]
then
        echo "OK - "$DEVICE" is "$SHOW_ROOT" used |USED="$ROOT_FORMAT"%;;;;"
        exit $STATE_OK
elif [ $ROOT_FORMAT -lt $CRITICAL_THRESHOLD ]
        then
        echo "CRITICAL -"$DEVICE" is "$SHOW_ROOT" used |USED="$ROOT_FORMAT"%;;;;"
        exit $STATE_CRITICAL
elif [ $ROOT_FORMAT -lt $WARNING_THRESHOLD ]
        then
        echo "WARNING - "$DEVICE" is "$SHOW_ROOT" used |USED="$ROOT_FORMAT"%;;;;"
        exit $STATE_WARNING
else
        echo "UNKNOWN |Unknown state"
        exit $STATE_UNKNOWN
fi
}

debug() {
echo $SHOW_ROOT
echo $ROOT_FORMAT
}

## MAIN
if [ ! $1 ]
        then run
fi

while [ $# -gt 0 ]; do
        case "$1" in
                -d | --dev)
                        shift
                        DEVICE=$1
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

