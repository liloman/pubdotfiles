#!/usr/bin/env bash

pidof DDNet && { echo "$0 already running"; exit 1;  }

started=0
status=$(pomodoro-client.py status)
[[ $status == started* ]] && started=1
((started)) && pomodoro-client.py pause
timew start teeworlds +nowork
/home/charly/Descargas/DDNet/DDNet
timew stop
((started)) && pomodoro-client.py pause
