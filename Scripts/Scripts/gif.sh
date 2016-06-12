#!/usr/bin/env bash
# Usage: gif.sh 
# liloman 2016
#
# Take a GIF of the current window until you press ctrl-d or till x seconds
# usage: ./$0 [x seconds]
#version 0.1

time=/tmp/gif.time
log=/tmp/gif.log
gif=/tmp/cast.gif

viewgif() {
    #wait some time to make the gif
    sleep 2
    echo "Created gif in $gif"
    echo "Showing gif"
    #to be able to launch mplayer from the script
    nohup mplayer $gif &> /dev/null &
}

makegif() {
    local noreplay=${1:-0}; shift
    local duration=
    \rm -f $gif
    if (($noreplay)); then
        duration=$noreplay
        read -p "You have $duration seconds to finish.Press any key to start" key
    else
        #sum & round the time column
        duration=$(awk '{s+=$1} END {printf "%3.0f\n", s}' $time)
    fi
    clear
    #apply 20 offset to Y to strip off the term header
    (byzanz-record $(xwininfo -id $(xdotool getactivewindow) | awk '
    /Absolute upper-left X/ { x = $4 }
    /Absolute upper-left Y/ { y = $4 + 20}
    /Width/                 { w = $2 }
    /Height/                { h = $2 - 20 }
    END                     { print "-x", x, "-y", y, "-w", w, "-h", h }
    ') "$@" -d $duration $gif &)
    if ((!$noreplay)); then
        scriptreplay --timing=$time $log 
        viewgif
    else
        ( { sleep $duration; viewgif; } &)
    fi
}

record() {
    needs() { hash $1 2>/dev/null; return $?; }
    for need in byzanz-record nohup scriptreplay xdotool xwininfo; do
        needs $need ||  { echo "Needs $need. Please install it"; return; }
    done
    echo "Logging started!. Type exit or Ctl-D to quit recording"
    script -q --timing=$time $log 
    echo "Ok everything recorded. Let's make a gif of it."
    read -p  "Press any key to continue" key
    makegif 
}

#If argument live session for arg seconds
[[ -z $1 ]] && record || makegif $1
