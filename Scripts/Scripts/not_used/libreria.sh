#!/bin/bash
set -x
#exec >>/tmp/debug_libreria
#exec 2>>/tmp/debug_libreria2

## Variables aosd_cat
#TIMING_MUSICA="--fade-out=900 --fade-in=10 --fade-full=4000"
#COLOR_MUSICA="--back-color=white  --fore-color=red  --back-opacity=195  --padding=20 --font=\"Trebuchet_40\""
#POSITION_MUSICA="-x 600 -y -730"
#
#OSD_MUSICA="aosd_cat  $POSITION_MUSICA $TIMING_MUSICA $COLOR_MUSICA"
#
#
#TIMING="--fade-out=2000 --fade-in=1 --fade-full=2000"
#COLOR="--back-color=white  --fore-color=red  --back-opacity=10  --padding=30 --font=\"Arial 24\""
#POSITION="-x 500 -y -700"
#
#OSD_VOLUMEN="aosd_cat $POSITION $TIMING $COLOR"

TIMING=4000 # miliseconds
OSD_MUSICA="xargs -0 /usr/bin/notify-send -t $TIMING -u normal"
OSD_VOLUMEN="xargs -0 /usr/bin/notify-send -t $TIMING -u normal"

# Muestra la cancion actual
if [ "$1" == "cancion_actual" ]
then
#  killall notify-send 
  PLAY=`xwininfo -root -tree | grep "Spotify - " | grep -v 'has no name' | sed 's,.*"Spotify - \(.\+\?\)":.*,\1,'`
  if [ "${PLAY}" ]; then
    echo "${PLAY}" | sed 's,\(.\+\) \xe2\x80\x93 \(.\+\),\2\n\1,' | $OSD_MUSICA
  else
    ARTIST=$(mocp -Q %artist)
    ALBUM=$(mocp -Q %album)
    TITLE=$(mocp -Q %song)
    LENGTH=$(mocp -Q %tt)
    LEFT=$(mocp -Q %tl)
    CANCION="$ARTIST -- $ALBUM -- $TITLE ($LENGTH - $LEFT)"
    echo $CANCION | $OSD_MUSICA
  fi
fi;

# Avanza o retrocede la cancion actual
if [ "$1" == "mueve_cancion" ]
then
if [ "$2" == "adelante" ]; then 
 SEG=5
else
 SEG=-5
fi

if [ "$(mocp -Q %state)" == "PAUSE" ]; then
  mocp -U  
  mocp -k $SEG 
  sleep 0.1 
  mocp -P
 else 
   mocp -k $SEG
fi
libreria.sh cancion_actual
fi;
