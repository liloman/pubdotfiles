#!/usr/bin/env bash
#Link indexedDB storage for tests

link_indexedDB() {
    #Firefox home
    local firhome=$HOME/.mozilla/firefox
    #Firefox storage
    local storage=($firhome/*.Oposiciones)
    #My storage name
    local link=$HOME/OPOS/apuntes/Varios/file++++home+charly+tests+index.html
    #add now if removed
    storage+=/storage/default

    #if not it doesn't exist create it
    [[ -d $storage ]] || mkdir -p $storage

    #Change to firefox storage dir
    cd $storage

    ln -sv $link .
}

link_indexedDB

