#!/usr/bin/env bash
#Show current song with icon from dbus Spotify

. ~/Scripts/libnotify

current_spotify_song() {
    local resul=$(dbus-send --print-reply --session --type=method_call \
        --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2  \
        org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')

    local img=$(echo "$resul" |egrep -A 1 "mpris:artUrl"|egrep -v "mpris:artUrl"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$)
    echo "$img"
    local artist=$(echo "$resul" |egrep -A 2 "artist"|egrep -v "artist"|egrep -v "array"|cut -b 27-|cut -d '"' -f 1|egrep -v ^$)
    echo "$artist"
    local album=$(echo "$resul" |egrep -A 2 "album"|egrep -v "album"|egrep -v "array"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$)
    echo "($album)\n"
    local title=$(echo "$resul" |egrep -A 1 "title"|egrep -v "title"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$)
    echo "$title"
}

mapfile -t res <<< "$(current_spotify_song)"
wget "${res[0]}" -O /tmp/cover.jpg -q

eval notify-send -t 5000 --hint=int:transient:1 -i /tmp/cover.jpg "'${res[1]}'" "'${res[@]:2}'"

