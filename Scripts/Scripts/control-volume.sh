#!/usr/bin/env bash
#Control active sink volume with the xf86 keybindings

# . ~/Scripts/libnotify

sound() {
    local act="${1? $0 Needs an action}"
    local sink=($(pactl list short sinks))

    if [[ $act == mute ]]; then
        pactl -- set-sink-mute $sink toggle
    elif [[ $act == raise ]]; then
        pactl -- set-sink-volume $sink +5%
    elif [[ $act == lower ]]; then
        pactl -- set-sink-volume $sink -5%
    else
        echo "Unknown action: $act"
    fi
}

sound $*
