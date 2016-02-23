#!/bin/bash
# Lanza un terminal con root y si ya existe lo muestra en el escritorio que se este
wmctrl -R 'Emperador'
if [ "$?" != "0" ]; then
   xterm -T Emperador -ls -g 110x25+581+18 -e 'su -' &
 #  wmctrl -r 'Emperador' -b add,skip_taskbar -v
 #  wmctrl -r 'Emperador' -b add,skip_pager -v # no funciona, apano con xterm :(
fi;
