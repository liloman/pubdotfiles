#!/usr/bin/env bash
#get the photo of today from nationalgeographic and use it as wallpaper

. $HOME/Scripts/libnotify

change_wallpaper() {
    #wallpaper url and title, need to be got from $com
    local url= title= line=
    local regex='<img src="([^"]*)".*alt="([^"]*)" />'
    local wallpaper=$HOME/.wallpaper-of-the-day
    local web=http://photography.nationalgeographic.com/photography/photo-of-the-day/
    ping -c 2 $wget
    #wait for network connectivity then
    (( $? )) && sleep 20
    local com="wget $web --tries=10 -O-"

    while IFS= read -r line; do
        if [[ $line =~ $regex ]]; then
            url="http:${BASH_REMATCH[1]}"
            title="${BASH_REMATCH[2]}"
            break
        fi
    done < <($com)

    if [[ -z $url ]]; then
        notify_err "doWallpaper failed.Couldn't retrieve the url" preferences-desktop-wallpaper
        return 1
    fi

    wget --tries=10 $url --quiet -O $wallpaper 
    pcmanfm -w  $wallpaper && notify "Background changed to:\n $title!" preferences-desktop-wallpaper
    return 
}

change_wallpaper 
