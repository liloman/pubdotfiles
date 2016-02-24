#!/bin/bash 
# Envia a lastfm la cancion nueva de moc mediante el evento OnSongChange
# unicamente la envia cuando no estan vacios ninguno de los campos
# sino lastfm no la incorpora a la lista ...
 
libreria.sh cancion_actual

ARTIST=$(mocp -Q %artist)
ALBUM=$(mocp -Q %album)
TITLE=$(mocp -Q %song)
LENGTH=$(mocp -Q %tt)

if [ "$ARTIST" == "Ann Baker" ]; then
 exit;
fi;

if [ -n "$ARTIST" -a -n "$ALBUM" -a -n "$TITLE" -a -n "$LENGTH" ] 
then	   
  /usr/lib/lastfmsubmitd/lastfmsubmit --artist "$ARTIST" --title "$TITLE" --length "$LENGTH" --album "$ALBUM"
fi;



