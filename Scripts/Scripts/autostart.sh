#!/usr/bin/env bash
#Execute these command once login in X

#Load notification library
. ~/Scripts/libnotify


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
task sync

#Sync local repos with origin for my repos ...
monitor ~/Scripts/sync_repos.sh 

#Move firefox profile to RAM
monitor ~/Scripts/firefox_sync.sh 

#Get current song from Spotify VB (daemon)
# monitor ~/Scripts/current_spotify_song.sh

#Launch pomodoroTasks (daemon) 
monitor ~/Clones/pomodoroTasks/pomodoro-daemon.sh 


# This script ($$) will run forever cause the some jobs above are daemons
# so maybe you can reutilize it to do some other tasks in the final loop ... :D


# Wait until all jobs are done!
while (( ${#procs[@]}> 0)); do sleep 10; done
