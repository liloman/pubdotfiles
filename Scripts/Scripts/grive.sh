#!/usr/bin/env bash
#sync local dirs with gogole drive
LDIR=~/OPOS/apuntes
. ~/Scripts/log.sh 
needs() { hash $1 &>/dev/null || { echo "Needs $1" >&2; exit 1; } }
needs inotifywait
cd $LDIR || exit 1

#Launch daemon
while true; do
    #wait TIMEOUT seconds or a new msg
    inotifywait -e modify -e move -e create -e delete &> /dev/null
    grive 2>&1 | tee -ai $RTLOG
    #let's wait 60 seconds
    sleep 60
done
