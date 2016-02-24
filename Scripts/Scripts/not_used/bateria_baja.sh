#!/bin/bash
FILE=/sys/class/power_supply/C1AC/status
ID="$(wmctrl -l | grep wmacpi | cut -d ' ' -f1)"
DESKTOP="$(wmctrl -l | grep wmacpi | cut -d ' ' -f2)"

[ ! $DESKTOP ] && DESKTOP=$(wmctrl -l | grep wmacpi | cut -d ' ' -f3)

if [ "$(cat $FILE)" = "Discharging" ] && [ ! "$DESKTOP" = "0" ]; then
  #wmctrl -v -i -r $ID -b add,sticky
  wmctrl -v -i -R $ID -t 0
elif  [ "$(cat $FILE)" != "Discharging" ] && [ "$DESKTOP" = "0" ]; then
#    wmctrl -v -i -r $ID -b remove,sticky
    echo "Al escritorio 2"
    wmctrl -v -i -R $ID -t 2
fi;
