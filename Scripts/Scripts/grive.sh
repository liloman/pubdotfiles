#!/usr/bin/env bash
#sync local dirs with gogole drive
. ~/Scripts/log.sh 
needs() { hash $1 &>/dev/null || { echo "Needs $1" >&2; exit 1; } }
LDIR=~/OPOS/apuntes
WAIT=60

needs inotifywait
cd $LDIR || exit 1

#Launch daemon
while true; do
    #wait TIMEOUT seconds or a new msg
    inotifywait -e modify -e move -e create -e delete -r $LDIR &> /dev/null
    #let's wait $WAIT seconds before doing anything
    echo waiting $WAIT seconds
    #sleep $WAIT 
    grive  
done
