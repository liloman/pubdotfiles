#!/usr/bin/env bash
#Launch and sync spotify cache between RAM and non-voltatile storage

spotify_sync() {
    hash rsync || { echo rsync must be installed!; return; }
    #Spotify home
    local spotifyhome="$HOME/.cache/spotify"
    #Spotify default cache
    local link=($spotifyhome/Data)
    #RAM directory 
    local volatile="/tmp/.spotify/Data"
    #Solid data
    local static=${link}.solid

    #cd into spotify cache dir
    cd "$spotifyhome"

    #First run of the day
    [[ -d $volatile ]] || mkdir -p -m0700 "$volatile"
    [[ -e $link ]] || { echo $link must exist!. ; return; }

    #if not already soft linked
    if [[ $(readlink $link) != $volatile ]]; then
        files=($link/*)
        #Move and make backup if not empty dir
        if (( ${#files[@]} > 1 )); then
            mv $link $static
            # local cache=${HOME}/.cache/mozilla/firefox/
            # [[ -d $cache ]] || mkdir -p "$cache"
            # tar zcfp ${cache}/firefox_profile_backup.tar.gz $static
        fi
        ln -s $volatile $link
    fi

    if [[ -f $link/.unpacked ]]; then
        rsync -a --delete --exclude .unpacked $link/ $static/
    else
        rsync -a $static/ $link/
        touch $link/.unpacked
    fi
}

pidof spotify && { echo "$0 already running"; exit 1;  }


# if [[ $HOSTNAME != uni ]]; then
# echo "Preparando"
# spotify_sync
# echo "Lanza spotify"
# spotify
# echo "syncronizando"
# spotify_sync
# else
# echo "Lanza spotify"
# spotify
# fi

#too damn sized, so no sync anymore ...
spotify
