#!/usr/bin/env bash
#Show current song from a Spotify generated file from a Windows VirtualBox

. ~/Scripts/libnotify

current_spotify_song() {
    local file=/tmp/.spotify/title.txt
    local title= artist= song=
    [[ -d ${file%/*} ]] || mkdir ${file%/*}
    [[ -e $file ]] || touch $file
    while true; do 
        if inotifywait -e modify $file; then
            #let's give chance to release the file to the batch (sync)
            sleep 2
            read -r title < $file
            title=${title//^\"/}
            #ctl-v + ctl-m  not ^M!
            title=${title///}
            [[ $title == Spotify ]] && { notify "PAUSED!" folder-music ; continue; }
            artist=${title%%-*}
            song=${title#*-}
            echo "title:$title artist:$artist song:$song"
            # covert art from http://www.last.fm/music/Joe+Farrell/_/Follow+Your+Heart
            notify "$title" folder-music
        fi
    done
}

current_spotify_song
