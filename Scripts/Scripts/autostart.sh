#!/usr/bin/env bash
#Execute these command once login in X

. ~/Scripts/libnotify

#Associative array for processes indexed by pid
declare -A procs
#Enable job control
set -m

#Control the childs notifying on error 
control_child() {
    local tmp=()
    local com
    for pid in "${!procs[@]}"; do
        com="${procs[$pid]}"
        if [ ! -d /proc/$pid ]; then
            wait $pid
            (($?)) && notify_err "Autostart process failed.\n$com" 
            unset procs[$pid]
        fi
    done
}


#Launch on background and monitor it until finish
launch() { 
    local com="$*"
    echo Launching in background:$com
    $com &
    #Grab its pid and command 
    procs[$!]="$com"
}

#Trap sigchild signal (see kill -l)
trap "control_child" SIGCHLD

#Move firefox profile to RAM
launch /home/charly/Scripts/firefox_sync.sh 

#Get current song from Spotify VB
launch /home/charly/Scripts/current_spotify_song.sh

#Launch pomodoroTasks daemon
launch /home/charly/Clones/pomodoroTasks/pomodoro-daemon.sh 

# Wait until all (background) processes are done!
while (( ${#procs[@]}> 0)); do sleep 1; done
