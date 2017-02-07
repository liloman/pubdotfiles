#!/usr/bin/env bash
#set the enviroment before/after teeworlds

pidof DDNet && { echo "$0 already running"; exit 1;  }

declare -i started=0

#disable notifications
killall notification-daemon
#get status
status=$(pomodoro-client.py status)
[[ $status == started* ]] && started=1
#only pause if started
((started)) && pomodoro-client.py pause
#track teeworlds
timew start teeworlds +nowork
#launch it
/home/charly/Descargas/DDNet/DDNet
#untrack teeworlds
timew stop
#if started then resume it
((started)) && pomodoro-client.py pause
#enable notifications
nohup /usr/libexec/notification-daemon >/dev/null &
