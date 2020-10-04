#!/usr/bin/env bash
#Download and install the current extension pack for virtualbox 

get_virtualbox_extpack() {
    local version=$(VBoxManage --version)
    #cut till first r
    local len=${version%_*}
    #get the r position
    len=${#len}
    local ver=${version:0:$len}
    local base="http://download.virtualbox.org/virtualbox"
    local pkg="${ver}_RPMFusion/Oracle_VM-${version:$len+1}.vbox-extpack"
    local pkg="Oracle_VM_VirtualBox_Extension_Pack-${ver}_${version:$len+1}_fedora31-1.x86_64.rpm"
 #    https://download.virtualbox.org/virtualbox/6.1.4/VirtualBox-6.1-6.1.4_136177_fedora31-1.x86_64.rpm
 #     ttp://download.virtualbox.org/virtualbox/6.1.4_RPMFusion/Oracle_VM_VirtualBox_Extension_Pack-6.1.4_RPMFusion_136177_fedora31-1.x86_64.rpm
    local url="$base/$ver_RPMFusion/$pkg"
    cd /tmp/
    echo "wgeting-> $url"
    wget "$url" || { echo "URL-> $url not found. Check the URL"; return; }
    echo Downloaded /tmp/"$pkg" 
    VBoxManage extpack install /tmp/"$pkg"
    VBoxManage list extpacks
}

get_virtualbox_extpack
