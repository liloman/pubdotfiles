#!/bin/bash 
set -x
exec > /tmp/debug_lyrics1
exec 2>/tmp/debug_lyrics2
#PATH='/usr/local/bin:/usr/bin:/bin:/usr/games:~/Scripts:/sbin'
#LESSCLOSE='/usr/bin/lesspipe %s %s'
#LESSOPEN='| /usr/bin/lesspipe %s'

 PLAY=`xwininfo -root -tree | grep "Spotify - " | grep -v 'has no name' | sed 's,.*"Spotify - \(.\+\?\)":.*,\1,'`
if [ "${PLAY}" ]; then
    ARTIST=$(echo $PLAY | sed 's,\(.\+\) \xe2\x80\x93 \(.\+\),\2\n\1,' | sed 's,\(.*\) - \(.*\),\1,')
    TITLE=$(echo $PLAY | sed 's,\(.\+\) \xe2\x80\x93 \(.\+\),\2\n\1,' | sed 's,\(.*\) - \(.*\),\2,') 
 else
   ARTIST=$(mocp -Q %artist)
   TITLE=$(mocp -Q %song)
fi

if [ -n "$ARTIST" -a -n "$TITLE" ] 
then	   
echo  "lyrics-moc.pl  --artist $ARTIST --title $TITLE"
 aterm  +sb  -geometry 85x55  -e  ~/Scripts/lyrics-moc.pl  --artist "$ARTIST" --title "$TITLE" &
fi;



