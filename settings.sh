#!/bin/bash
#Several settings

echo "Setting autostart configuration"
run=""

if [[ -x /usr/libexec/notification-daemon ]]; then
    echo Autostarting notification-daemon
    run+="@/usr/libexec/notification-daemon\n"
fi


if [[ -x ~/Scripts/runBash.sh ]]; then
    echo Autostarting firefox_sync
    run+="$HOME/Scripts/runBash.sh firefox_sync\n"
fi
[[ -d ~/.config/lxsession/LXDE/ ]] || mkdir -p ~/.config/lxsession/LXDE
echo -e "$run" > ~/.config/lxsession/LXDE/autostart
