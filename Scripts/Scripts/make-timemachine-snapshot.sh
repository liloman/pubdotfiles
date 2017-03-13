#!/usr/bin/env bash
#Launch the snapshot of configurated files in ~/.tm-excluderc
# and save it in $dest 

launch() {
    local orign=$HOME
    local dest=$HOME/TimeMachine/
    local rsync=$HOME/.local/bin/rsync_tmbackup.sh
    local options=' --rsync-set-flags "'

    for flag in $($rsync --rsync-get-flags); do
        #disable one-file-system flag to be able to rsync bind mounts :)
        [[ $flag != --one-file-system ]] && options+=" $flag"
    done
    options+='"'

    eval $rsync "$options" $orign $dest ~/.tm-excluderc  

}

launch 
