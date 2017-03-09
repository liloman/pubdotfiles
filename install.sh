#!/bin/bash
# Install script for my dotfiles
# Copyright © 2016 liloman
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#version 0.1 "basic" config
#version 0.2 Added mplayer files
#version 0.3 Refactoring and bash_functions
#version 0.4 Changed to stow

#TODO
#Needs some function to "move" the files when stow fails

__ScriptVersion="0.4"

hash stow || { echo "Must install stow first"; exit 1; }

function usage ()
{
cat <<- EOT

  Usage :  $0 [options] [--]

  Options:
  -h|help       Display this message
  -v|version    Display script version
  -d|desktop    Full version  
  -a|ask        Dont ask for passwords
  -s|server     Server version

EOT
}   

function do_symlink ()
{
  local orig=$1 dest=$2
  [[ ! -f $orig ]] && echo "Warning: $orig doesn't exist." || ln -s $orig $dest   
}

ask=1

while getopts ":hvdsa" opt
do
  case $opt in
    h|help     )  usage; exit 0   ;;
    v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
    d|desktop  )  type=desktop ; ;;
    s|server   )  type=server  ; ;;
    a|ask      )  ask=0        ; ;;
    \? )  echo -e "\n  Option does not exist : $OPTARG\n"; usage; exit 1   ;;
     : )  echo "Option -$OPTARG needs an argument"; exit 1 ;;
  esac 
done
shift $(($OPTIND-1))

[[ -z $type ]] && { echo "Needs arguments, execute $0 -h for help"; exit 1; }


cd ~/dotfiles

echo Lets install type:$type for $USER then!

#############
#  INSTALL  #
#############

echo Installing dotfiles for $type

stow -vS bash
stow -vS asyncBash
stow -vS vim
stow -vS home
stow -vS htop 
completions=~/.local/share/bash-completion/completions
#if not a symlink
[[ -d $completions && ! -L $completions ]] && rmdir $completions
#make it a symlink 
stow -vS bash_completions

#If not server
if [[ $type != server ]]; then
    stow -vS X
    stow -vS vimperator
    stow -vS mplayer
    stow -vS xdg 
    stow -vS lxde 
    stow -vS Scripts 
    stow -vS firejail 
    #symlinks
    do_symlink "$HOME/Clones/bash-surround/inputrc-surround" "$HOME/.inputrc-surround"
    shopt -s dotglob
    cp -rvuP $PWD/systemd/* $HOME && { 
    systemctl --user daemon-reload;
    systemctl --user enable change-wallpaper.timer;
    systemctl --user start change-wallpaper.timer;
    systemctl --user enable timemachine.timer;
    systemctl --user start timemachine.timer;
    #The user services need to be enabled and WantedBy in [Install]
    #otherwise they need to be started manually
    systemctl --user enable on-logout.service;
    }
    if ((ask)); then
        echo "*****START******"
        echo "Let's install the root stuff"
        # $USER == local user (not the root user)
        su -c '
        echo "Enabling sleep@$USER "
        cp -v root/sleep@.service /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable sleep@$USER
        echo "*****END******"
        '
    fi
fi

#######################
#  UPDATE SUBMODULES  #
#######################

echo Installing submodules
git submodule init

echo Updating submodules 
git submodule update  --init --remote

if [[ ! -e ~/.local/share/fonts/Literation Mono Powerline.ttf ]]; then
    echo "Installing powerline fonts"
    ./vim/.vim/bundle/powerline-fonts/install.sh
fi

echo Install script done!.
