#!/usr/bin/env bash
#Download and install the current extension pack for virtualbox 

get_virtualbox_extpack() {
    local version=$(VBoxManage --version)
    #cut till first r
    local len=${version%r*}
    #get the r position
    len=${#len}
    local ver=${version:0:$len}
    local base="http://download.virtualbox.org/virtualbox"
    local pkg="Oracle_VM_VirtualBox_Extension_Pack-$ver-${version:$len+1}.vbox-extpack"
    local url="$base/$ver/$pkg"
    cd /tmp/
    echo "wgeting-> $url"
    wget "$url" || { echo "URL-> $url not found. Check the URL"; return; }
    echo Downloaded /tmp/"$pkg" 
    VBoxManage extpack install /tmp/"$pkg"
    VBoxManage list extpacks
}

get_virtualbox_extpack
