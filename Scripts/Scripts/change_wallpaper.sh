#!/usr/bin/env bash
#get the photo of today from nationalgeographic and use it as wallpaper

. $HOME/Scripts/libnotify

change_wallpaper() {
    #wallpaper url and title, need to be got from $com
    local url= title= line=
    #they make a breakline in alt, so no trailing "
    #local regex='<img src="([^"]*742.jpg)".*alt="([^"]*)'
    local regexI='property="og:image" content="(.*)"'
    local regexT='property="og:title" content="(.*)"'
    local regexD='"dek":\{"text":"<p>(.*)<\\/p>","hide":true}},"kicker":'
    local wallpaper=$HOME/.wallpaper-of-the-day
    local wtitle=/tmp/.wallpaper-of-the-day-title
    local wdesp=/tmp/.wallpaper-of-the-day-title
    local web=http://photography.nationalgeographic.com/photography/photo-of-the-day/
    ping -c 2 photography.nationalgeographic.com
    #wait for network connectivity then
    (( $? )) && sleep 20
    local com="wget $web --tries=10 --quiet -O-"

    while IFS= read -r line; do
        if [[ $line =~ $regexT ]]; then
            title="${BASH_REMATCH[1]}"
            echo "title: $line"
        elif [[ $line =~ $regexI ]]; then
            url="${BASH_REMATCH[1]}"
        elif [[ $line =~ $regexD ]]; then
            title+="\n ${BASH_REMATCH[1]}"
            break
        fi
    done < <($com)

    if [[ -z $url ]]; then
        notify_err "doWallpaper failed.Couldn't retrieve the url" preferences-desktop-wallpaper
        return 1
    fi

    # wget --tries=10 $url --quiet -O $wallpaper 
    wget --tries=10 $url -O $wallpaper 
    echo $title > /tmp/.change_wallpaper.title
    pcmanfm -w  $wallpaper && notify "Background changed to:\n $title!" preferences-desktop-wallpaper 10
    echo $title > $wtitle
    echo "Downloaded: $url with title: $title"
}

change_wallpaper 
