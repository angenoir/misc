#!/bin/bash

######################################################################
#This software is published by Valentin COMTE under the WTFPL Licence#
######################################################################
# * This program is free software. It comes without any warranty, to #
# * the extent permitted by applicable law. You can redistribute it  #
# * and/or modify it under the terms of the Do What The Fuck You Want#
# * To Public License, Version 2, as published by Sam Hocevar. See   #
# * http://sam.zoy.org/wtfpl/COPYING for more details.               #
######################################################################
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE             #
#                    Version 2, December 2004                        #
#                                                                    #
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>                   #
#                                                                    #
# Everyone is permitted to copy and distribute verbatim or modified  #
# copies of this license document, and changing it is allowed as long#
# as the name is changed.                                            #
#                                                                    #
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE             #
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION  #
#                                                                    #
#  0. You just DO WHAT THE FUCK YOU WANT TO.                         #
######################################################################


## GLOBAL VARS
## (Dirty) Conversion to human readble values
MEMTOT=`cat /proc/meminfo | head -n 1 |awk '{print $2}'`
MEMFREE=`cat /proc/meminfo | head -n 2 | tail -n 1 |awk '{print $2}'`
MEMUSED=$(( MEMTOT-MEMFREE ))
MEMTOTK=$(( MEMTOT/1000 ))
MEMTOTM=$(( MEMTOT%1000 ))
MEMFREEK=$(( MEMFREE/1000 ))
MEMFREEM=$(( MEMFREE%1000 ))
MEMUSEDK=$(( MEMUSED/1000 ))
MEMUSEDM=$(( MEMUSED%1000 ))
MEMBUFF=`cat /proc/meminfo | head -n 3 | tail -n 1 |awk '{print $2}'`
MEMCACHE=`cat /proc/meminfo | head -n 4 | tail -n 1 |awk '{print $2}'`
MEMFREEUNBUFFERED=$(( MEMFREE+MEMBUFF+MEMCACHE ))
MEMUSEDUNBUFFERED=$(( MEMUSED-MEMBUFF-MEMCACHE ))
MEMFREEUNBUFFEREDK=$(( MEMFREEUNBUFFERED/1000 ))
MEMFREEUNBUFFEREDM=$(( MEMFREEUNBUFFERED%1000 ))
MEMUSEDUNBUFFEREDK=$(( MEMUSEDUNBUFFERED/1000 ))
MEMUSEDUNBUFFEREDM=$(( MEMUSEDUNBUFFERED%1000 ))
MEMCACHEK=$(( MEMCACHE/1000 ))
MEMCACHEM=$(( MEMCACHE%1000 ))
PERCENT=`echo "scale=2; ($MEMUSEDUNBUFFERED/$MEMTOT)*100" | bc`
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
## Default values if none is set
declare -i WARNING_THRESHOLD=85
declare -i CRITICAL_THRESHOLD=95
NAGIOS=0
VERSION="1.6-26072012"
## END OF THE GLOBAL VARS BLOCK


## FUNCTIONS
nagios() {
	CMP_CRIT=$(echo "$PERCENT >= $CRITICAL_THRESHOLD" | bc -l)
	CMP_WARN=$(echo "$PERCENT >= $WARNING_THRESHOLD" | bc -l)
	if [ $CMP_CRIT = 1 ]
                then echo "CRITICAL - "$PERCENT"% ("$MEMUSEDUNBUFFERED.$MEMUSEDUNBUFFEREDM"MB used) |TOTAL="$MEMTOTK.$MEMTOTM"MB;;;; USED="$MEMUSEDUNBUFFEREDK.$MEMUSEDUNBUFFEREDM"MB;;;; FREE="$MEMFREEUNBUFFEREDK.$MEMFREEUNBUFFEREDM"MB;;;; CACHES="$MEMCACHEK.$MEMCACHEM"MB;;;;"
                exit $STATE_CRITICAL
	elif [ $CMP_WARN = 1 ]
        	then echo "WARNING - "$PERCENT"% ("$MEMUSEDUNBUFFERED.$MEMUSEDUNBUFFEERDM"MB used) |TOTAL="$MEMTOTK.$MEMTOTM"MB;;;; USED="$MEMUSEDUNBUFFEREDK.$MEMUSEDUNBUFFEREDM"MB;;;; FREE="$MEMFREEUNBUFFEREDK.$MEMFREEUNBUFFEREDM"MB;;;; CACHES="$MEMCACHEK.$MEMCACHEM"MB;;;;"
		exit $STATE_WARNING
	elif [ $CMP_WARN = 0 ]
		then echo "OK - "$PERCENT"% ("$MEMUSEDUNBUFFEREDK.$MEMUSEDUNBUFFEREDM"MB used) |TOTAL="$MEMTOTK.$MEMTOTM"MB;;;; USED="$MEMUSEDUNBUFFEREDK.$MEMUSEDUNBUFFEREDM"MB;;;; FREE="$MEMFREEUNBUFFEREDK.$MEMFREEUNBUFFEREDM"MB;;;; CACHES="$MEMCACHEK.$MEMCACHEM"MB;;;;"
                exit $STATE_OK
	else
		echo "UNKNOWN |Unknown state"
		exit $STATE_UNKNOWN
	fi
}
help() {
        echo "Usage : ./check_freemem.sh [-n | --nagios] [-w | --warning] [-c | --critical] [-H | --human] [-b | --buffered] [-v | --version] [-h | --help] "
	echo ""
	echo "Example : check_freemem.sh -n -w 90 -c 95"
	echo "			"
        echo "		-n | --nagios To return results that will be parsed by nagios/shinken/icinga"
        echo "		-w | --warning To set the warning value, in percent, the default value is 85"
        echo "		-c | --critical To set the critical value, in percent the default value is 95"
        echo "		-H | --human To return used memory, free memory and total memory in human readable format"
	echo "		-b | --buffered To display used memory with the cached and buffered memory"
	echo "		-v | --version To display the version of the script, based on the golden-ratio and the day+month+year of the revision"
	echo "		-h | --help To display this help message"
	echo ""
	exit $STATE_OK
}
display_human() {
        ## If we have enough memory
        if [[ $MEMTOT>=1000 ]]
                then echo "Used memory : $MEMUSEDK.$MEMUSEDM MB; Free memory : $MEMFREEK.$MEMFREEM MB ; Total : $MEMTOTK.$MEMTOTM MB"
        else
                echo "Mémoire Totale : $MEMTOT"
                echo "Mémoire Libre : $MEMFREE"
                echo "Mémoire Utilisée : $MEMUSED"
        fi
	exit $STATE_OK
}

run() {
	if [ $WARNING_THRESHOLD = 0 ] || [ $CRITICAL_THRESHOLD = 0 ]
        then echo "The critical/warning values must be stricly >0 and/or numeric !"
        exit $STATE_CRITICAL
	fi

	local  CMP=$(echo "$WARNING_THRESHOLD > $CRITICAL_THRESHOLD-1" | bc -l)
	if [ $CMP = 1 ]
                then echo "The critical value must be higher than the warning one !"
                exit $STATE_CRITICAL
        fi

	if [ $NAGIOS = 1 ]
		then nagios
	else
		help
	fi
}

version() {
	echo "check_local_mem v"$VERSION""
	exit $STATE_OK
}
## END OF THE FUNCTION BLOCK



## Run

## Check if $1 is empty
if [ ! $1 ]
	then help
	exit $STATE_OK
fi

## Parse parameters
while [ $# -gt 0 ]; do
    case "$1" in
        -h | --help)
            help
            exit $STATE_OK
            ;;
        -v | --version)
                version
                exit $STATE_OK
                ;;
        -w | --warning)
                shift
                WARNING_THRESHOLD=$1
                ;;
        -c | --critical)
               shift
                CRITICAL_THRESHOLD=$1
                ;;
        -n | --nagios)
               NAGIOS=1
                ;;
	-H |--human)
		display_human
		;;
        *)  echo "Unknown argument: $1"
            help
            exit $STATE_UNKNOWN
            ;;
        esac
shift
done
run
## END OF THE RUN BLOCK
