#!/usr/bin/env bash
#Execute these command once login in X

#Load notification library
. ~/Scripts/libnotify

try=0
no_conexion=0

#wait for 150 seconds for connectivity before doing anything network related
while ! ping -c 1 google.es &> /dev/null;
do
    ((try++))
    if ((try == 30));
    then
        notify_err "no conexion"
        no_conexion=1
    fi
    sleep 5
done

#Associative array for processes indexed by pid
declare -A procs
#Enable job control
set -m
#Execute control_child each 1 sec till jobs remaining (see kill -l for signals)
trap "control_child" SIGCHLD

#Control the childs notifying on error 
control_child() {
    local tmp=()
    local com
    for pid in "${!procs[@]}"; do
        if [ ! -d /proc/$pid ]; then
            com="${procs[$pid]}"
            wait $pid
            (($?)) && notify_err "Autostart process failed.\n$com" 
            unset procs[$pid]
        fi
    done
}


#Launch on background $com and monitor it for errors until it finishes
monitor() { 
    local com="$*"
    echo Launching in background:$com
    #eval for if you want to launch several commands at one :S
    eval $com &
    #Grab its pid and command 
    procs[$!]="$com"
}


#Sync tasks
((no_conexion)) || { task sync ||  notify_err "task sync failed" }

( tilda  ||  notify_err "tilda failed to start" ) &

task diagnostics | grep "Found duplicate"  && notify_err "duplicates on taskwarrior use remove-du..."


#Remove that shit out of here all along (not able to disable/modify...)
rm -rf ~/Downloads/ ~/Desktop/

#Sync local repos with origin for my repos ...
((no_conexion)) || monitor ~/Scripts/sync_repos.sh 

#Move firefox profile to RAM
monitor ~/Scripts/firefox_sync.sh 

#Sync google drive dir
monitor ~/Scripts/grive.sh 

#Track shutdown time on timewarrior (no argument for just the last one)
monitor ~/.local/bin/last-boots.sh

#Get current song from Spotify VB (daemon)
# monitor ~/Scripts/current_spotify_song.sh

#default pomodoro session (minutes)
export POMODORO_TIMEOUT=25
#default pomodoro short break (minutes)
export POMODORO_STIMEOUT=5
#default pomodoro long break (minutes)
export POMODORO_LTIMEOUT=15
#Launch pomodoroTasks2 (daemon) 
monitor ~/.local/bin/pomodoro-daemon.py

#Stop active task on logout
systemctl --user start on-logout.service


# This script ($$) will run forever cause the some jobs above are daemons
# so maybe you can reutilize it to do some other tasks in the final loop ... :D


# Wait until all jobs are done!
while (( ${#procs[@]}> 0)); do sleep 10; done
