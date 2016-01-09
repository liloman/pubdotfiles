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

__ScriptVersion="0.4"

hash stow || { echo "Must install stow first"; exit 1; }

function usage ()
{
cat <<- EOT

  Usage :  $0 [options] [--]

  Options:
  -h|help       Display this message
  -v|version    Display script version
  -u|user       Full version  (BASH,VIM,TMUX,WEB, MPLAYER)
  -s|server     Server version (BASH, VIM)

EOT
}   

while getopts ":hvus" opt
do
  case $opt in
    h|help     )  usage; exit 0   ;;
    v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
    u|user     )  type=user ; break ;;
    s|server   )  type=server ; break ;;
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
stow -vS vim
stow -vS tmux
stow -vS gem

#If server exit
[[ "$type" == "server" ]] && exit 0

stow -vS X
stow -vS vimperator
stow -vS mplayer
stow -vS lxde

#######################
#  UPDATE SUBMODULES  #
#######################

echo Installing submodules
git submodule init

echo Updating submodules 
git submodule update  --init --remote

echo Install script Done!.
