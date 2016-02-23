#!/usr/bin/env bash
#Clean firefox profiles

cleanFirefox() {
    local profile="$1"; shift
    local wdirs="storage/  minidumps/"
    local rdirs="crashes/ datareporting healthreport/ saved-telemetry-pings/"
    [[ -z $profile ]] && { echo "Needs a profile"; return ; }

    cd ~/.mozilla/firefox/*.$profile 2>/dev/null || { echo "Profile:$profile incorrect"; return ; }


    echo "Doing clean up in firefox $profile"

    echo "Wiping readonly dirs..."
    for dir in $rdirs; do
        [[ -d $dir ]] || continue
        echo "Doing $dir"
        chmod a+w $dir
        rm -rfv $dir/*
        chmod a-w $dir
    done

    echo "Wiping writable dirs..."

    for dir in $wdirs; do
        [[ -d $dir ]] || continue
        echo "Doing $dir"
        rm -rfv $dir/*
    done

    echo "Wiping cache for $profile..."
    rm -rf ~/.cache/mozilla/firefox/*.$profile

    echo "Done!"
}

cleanFirefox $1
