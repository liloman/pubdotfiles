#!/usr/bin/env bash
#Executed before/after sleep.target
action=$1

#if suspending
if [[ $action == suspend ]]; then
    #Disable the keyboard so don't wake up the pc when suspended
    echo -n "Fixing acpi settings."
    for usb in $(cat /proc/acpi/wakeup | grep USB | cut -f1);
    do
        grep $usb /proc/acpi/wakeup | grep enable -q
        (( $? ==0 )) && echo $usb > /proc/acpi/wakeup
    done
    echo "$1-ing done!" 

    #Pause current task
    echo "Pause current task"
    /home/$USER/.local/bin/pomodoro-client.sh pause
    #Starting timew pomodoro
    echo "Starting timew pomodoro"
    timew start 'Suspend' +work

else #resuming
    echo "Stopping timew pomodoro"
    timew stop
    #Restart current task
    echo "Restart current task"
    /home/$USER/.local/bin/pomodoro-client.sh reset
fi
