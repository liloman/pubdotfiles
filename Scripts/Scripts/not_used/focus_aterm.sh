#!/bin/bash
# Muestra en primer plano las consolas del escritorio y va alternando entre ellas
# Interesante para poder alternar entre las diferencias ventanas de una misma aplicacion

ACTUAL_WORKSPACE=$(wmctrl -d | grep \* | cut -d' ' -f1)
FILE_TMP=/tmp/.list_tmp 
FILE=/tmp/.list_aterms 


#wmctrl -l | grep "$ACTUAL_WORKSPACE $(hostname)" | grep Aterm | cut -d' ' -f1 | sort -n > $FILE_TMP;
#if [ -e $FILE && $(diff -q $FILE_TMP $FILE) ]; 
#then
#fi

 

for TASKBAR_WINDOW in  $(wmctrl -l | grep "$ACTUAL_WORKSPACE $(hostname)" | grep Aterm | cut -d' ' -f1 | sort -n); do 
  echo "";
done;
wmctrl -i -a $TASKBAR_WINDOW
# Sino existe ninguna se lanza ...
[ -z $TASKBAR_WINDOW ] && aterm 

#  [ "$?" != "0" ] && xterm -T Emperador -ls -g 110x25+581+18 -e 'su -' &
