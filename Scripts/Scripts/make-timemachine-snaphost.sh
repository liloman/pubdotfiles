#!/usr/bin/env bash

#Launch the snapshot of configurated files in ~/.tm-excluderc
# and save it in $dest 

orign=~
dest=~/TimeMachine/

if [[ $HOSTNAME == uni ]]; then
    ~/.local/bin/rsync_tmbackup.sh $orign $dest  ~/.tm-excluderc  
fi
