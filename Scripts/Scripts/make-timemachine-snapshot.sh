#!/usr/bin/env bash
#Launch the snapshot of configurated files in ~/.tm-excluderc
# and save it in $dest 

launch() {
    local orign=$HOME
    local dest=$HOME/TimeMachine/
    local rsync=$HOME/.local/bin/rsync_tmbackup.sh
    local options=' --rsync-set-flags "'
    local flags=/dev/shm/flags

    $rsync --rsync-get-flags > $flags
    #remove the new comment 
    sed -i '2d' $flags

    for flag in $(< $flags); do
        #disable one-file-system flag to be able to rsync bind mounts :)
        [[ $flag != --one-file-system ]] && options+=" $flag"
    done
    options+='"'
    rm -f $flags

    set -x
    eval $rsync "$options" $orign $dest ~/.tm-excluderc  
    #echo $rsync "$options" $orign $dest ~/.tm-excluderc  
    set +x

}

launch 
