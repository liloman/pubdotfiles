#!/usr/bin/env bash
#sync local dirs with gogole drive
. ~/Scripts/log.sh 
needs() { hash $1 &>/dev/null || { echo "Needs $1" >&2; exit 1; } }
LDIR=~/OPOS/apuntes
WAIT=60
TIMEOUT=$((60*15))

needs inotifywait
cd $LDIR || exit 1

#launch grive one time when started
grive  

#Launch daemon
while true; do
    #wait TIMEOUT seconds or a new msg
    inotifywait -t $TIMEOUT -e modify -e move -e create -e delete -r $LDIR &> /dev/null
    ret=$?
    #let's wait $WAIT seconds before doing anything if it's not a timeout event
    if (($ret != 2)); then
        echo waiting $WAIT seconds
        sleep $WAIT 
    fi
    grive  
done
