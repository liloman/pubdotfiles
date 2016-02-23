#!/usr/bin/env bash
#Sync & set firefox profile between RAM and non-voltatile storage

firefox_sync() {
    hash rsync || { echo rsync must be installed!; return; }
    #Firefox home
    local firhome="$HOME/.mozilla/firefox"
    #Firefox default profile
    local profile=($firhome/*.default)
    #RAM directory 
    local volatile="/tmp/firefox-$USER"
    #My profile name
    local link=${profile##*/}
    local static=${link}.solid

    #Changed to firefox home dir
    cd "$firhome"

    #First run of the day
    [[ -d $volatile ]] || mkdir -m0700 "$volatile"
    [[ -e $link ]] || { echo $link must exist!. ; return; }

    #if not already soft linked
    if [[ $(readlink $link) != $volatile ]]; then
        files=($link/*)
        #Move and make backup if not empty dir
        if (( ${#files[@]} > 1 )); then
            mv $link $static
            local cache=${HOME}/.cache/mozilla/firefox/
            [[ -d $cache ]] || mkdir -p "$cache"
            tar zcfp ${cache}/firefox_profile_backup.tar.gz $static
        fi
        ln -s $volatile $link
    fi


    if [[ -f $link/.unpacked ]]; then
        rsync -a --delete --exclude .unpacked ./$link/ ./$static/
    else
        rsync -a ./$static/ ./$link/
        touch $link/.unpacked
    fi
}

firefox_sync
