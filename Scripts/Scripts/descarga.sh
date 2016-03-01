#!/usr/bin/env bash
#Download a vid and play it in FS from bash or vimperator or whatever

. ~/Scripts/libnotify

descarga() {
    local latest=false
    local dest=$HOME/Descargas/videoFlash
    local url="$1"
    # local options=" $url --add-metadata  --verbose -o $dest -f best --no-part "
    # failing --add-metadata option
    local options=" $url --verbose -o $dest -f best --no-part "
    killall -q youtube-dl
    cd ~ # youtube-dl doesn't get DEST right ¿?
    \rm -f $dest
    > $dest
    #Failback for latest youtube-dl in case of errors on fedora's one
    if [[ $latest = true ]]; then
        if [[ ! -x "~/Scripts/youtube-dl" ]]; then 
            wget https://yt-dl.org/latest/youtube-dl -O ~/Scripts/youtube-dl
            chmod +x ~/Scripts/youtube-dl
        fi
        ~/Scripts/youtube-dl $options >/tmp/youtube.log &
    else
        youtube-dl $options >/tmp/youtube.log &
    fi
    local downloading=$!
    # echo  "pgrep: $(pgrep -aw youtube-dl) downloading pid:$downloading" 
    read tam _ <<< $(du -b $dest)
    # Wait for 1M file or 1 minute
    local count=0
    while (( $tam < 1000000   )); do 
        read tam _ <<< $(du -b $dest)
        sleep 0.5
        ((count++))
        ((  count > 120 )) && break
    done
    #It needs nohup to work on bash cli also
    nohup mplayer -fs $dest >/dev/null & 
    #it'd be better get the metadata working on local file but it doesn't work already
    local title="$(youtube-dl -e "$url")"
    wait $downloading && notify "Video downloaded for $title!" smplayer
}

descarga $1
