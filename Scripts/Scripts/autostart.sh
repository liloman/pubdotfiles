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


#wait for 150 seconds for connectivity before doing anything network related
do_network_jobs() {
    local -i network=0
    local -i try=0
    while ! ping -c 1 google.es &> /dev/null;
    do
        ((try++))
        if ((try == 30));
        then
            notify_err "no conexion"
            network=1
        fi
        sleep 5
    done
    #Sync tasks
    if ! ((network)); then 
        task sync ||  notify_err "task sync failed" 
        #Sync local repos with origin for my repos ...
        monitor ~/Scripts/sync_repos.sh 
    fi
}

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


#Remove that shit out of here all along (not able to disable/modify...)
rm -rf ~/Downloads/ ~/Desktop/

( tilda  ||  notify_err "tilda failed to start" ) &

task diagnostics | grep "Found duplicate"  && notify_err "duplicates on taskwarrior use remove-du..."

#Move firefox profile to RAM
monitor ~/Scripts/firefox_sync.sh 

#Sync google drive dir
monitor ~/Scripts/grive.sh 

#default pomodoro session (minutes)
export POMODORO_TIMEOUT=25
#default pomodoro short break (minutes)
export POMODORO_STIMEOUT=5
#default pomodoro long break (minutes)
export POMODORO_LTIMEOUT=15
#Launch pomodoroTasks2 (daemon) 
monitor ~/.local/bin/pomodoro-daemon.py

#Launch network jobs
do_network_jobs &



# This script ($$) will run forever cause the some jobs above are daemons
# so maybe you can reutilize it to do some other tasks in the final loop ... :D

# Wait until all jobs are done!
while (( ${#procs[@]}> 0)); do sleep 10; done
