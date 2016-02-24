#!/bin/bash
#It is executed Before=suspend.target
. ~/.bash_functions

echo "check" > /tmp/doing
VBoxManage showvminfo Spotify --machinereadable  >> /tmp/doing
if VBoxManage showvminfo Spotify --machinereadable |  grep VMState=\"running\" -q; then
    echo -n "Pausing Spotify."
    VBoxManage controlvm "Spotify" pause && notify  "Spotify paused!" virtualbox
    echo "Done!."
echo "**************************" >> /tmp/doing
fi
echo "dldld" >> /tmp/doing
