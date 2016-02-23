#!/usr/bin/env bash
#Alternate between running/saved/paused/power off states of a VMVB

. ~/.bash_functions

alternate_vbox() {
    local machine="${1? $0 Needs a machine name}"
    local pause="$2"
    #Not Greedy state
    local regex='(State:)([[:space:]]*)([-[:alnum:][:space:]]*)([[:space:]].*)'

    #Get the VM info
    readarray -t info <<< "$(VBoxManage showvminfo "$machine" 2>/dev/null)" 
    #Search regex onto full array
    [[ ${info[@]} =~ ${regex} ]] || { echo "$machine not found"; return; }

    local state="${BASH_REMATCH[3]}"
    echo $machine State was:"\"$state\""

    if [[ $state == "paused" ]]; then
        VBoxManage controlvm "$machine" resume && \ 
        notify  "$machine resumed!" virtualbox
    fi

    case $state in saved|"powered off") VBoxManage startvm "$machine" --type headless && \
        notify  "$machine started!" virtualbox ;;
    esac

    if [[ $state == "running" ]]; then
        if [[ $pause ]]; then
            VBoxManage controlvm "$machine" pause && \
                notify  "$machine paused!" virtualbox
        else # Save state to hard disk
            VBoxManage controlvm "$machine" savestate && \
                notify  "$machine was saved!" virtualbox
        fi
    fi
}

alternate_vbox $*
