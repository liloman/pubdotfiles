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

    #Stop current task
    echo "Stopping current task"
    /home/$USER/.local/bin/pomodoro-client.py stop
    #Starting timew pomodoro
    echo "Starting timew pomodoro"
    timew start 'Suspend' +nowork

else #resuming
    echo "Stopping timew pomodoro"
    timew stop
    #Start current task
    echo "Starting current task"
    /home/$USER/.local/bin/pomodoro-client.py start
fi
