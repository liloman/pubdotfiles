#!/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/lib/
FICH=/tmp/moc_info


# Si ya esta corriendo nuestro demonio terminamos
[ "$$" != "`pgrep -fo $0`" ] && exit 0

# Esperamos un tiempo por si es la primera vez que espere a que se haya terminado de ejecutar el alias
sleep 10s

while true
do
  # Sino esta corriendo el demonio moc terminamos nuestro demonio	
  [ "$(pidof mocp)" ] || break

  # Si existe el fichero entonces recogemos el mp3 antiguo
  if [ -f $FICH ]; then
   ARTIST_OLD=$(grep ^Artist: $FICH  | cut -c 9-)
    ALBUM_OLD=$(grep ^Album: $FICH  | cut -c 8-)
    TITLE_OLD=$(grep ^SongTitle: $FICH  | cut -c 12-)
   LENGTH_OLD=$(grep ^TotalTime: $FICH  | cut -c 12-)
  fi;
  mocp -i > $FICH
  # Parseamos el fichero
  ARTIST=$(grep ^Artist: $FICH  | cut -c 9-)
   ALBUM=$(grep ^Album: $FICH  | cut -c 8-)
   TITLE=$(grep ^SongTitle: $FICH  | cut -c 12-)
  LENGTH=$(grep ^TotalTime: $FICH  | cut -c 12-)
  if [ -n "$ARTIST" -a -n "$ALBUM" -a -n "$TITLE" -a -n "$LENGTH" ] && \
    ( [ ! -f $FICH ] ||  [ "$ARTIST_OLD" != "$ARTIST" -o "$ALBUM_OLD" != "$ALBUM" -o "$TITLE_OLD" != "$TITLE" -o "$LENGTH_OLD" != "$LENGTH" ] );
  then	   
   /usr/lib/lastfmsubmitd/lastfmsubmit --artist "$ARTIST" --title "$TITLE" --length "$LENGTH" --album "$ALBUM"
  fi;
  # Dormimos 1 minuto
  sleep 1m
done
