#!/bin/bash
# Install script for my dotfiles
# Copyright © 2015 liloman
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

BACKUP=~/.dotfiles_backup/
BASH=" bashrc inputrc bash_profile bash_logout git-completion.bash git-prompt.sh ctags bash_aliases bash_functions"
X=" Xresources Xdefaults Xmodmap"
TMUX=" tmux.conf"
VIM=" vim vimrc"
WEB=" vimperatorrc vimperator/plugin"
LXDE=" lxde-rc.xml"
__ScriptVersion="0.3"

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

[[ -z "$type" ]] && echo $0 needs arguments. Execute $0 -h for help. &&  exit 0

[[ "$type" == "user" ]] && INSTALL=$BASH$VIM$WEB$X$TMUX
[[ "$type" == "server" ]] && INSTALL=$BASH$VIM 

echo Lets install type:$type for $USER then!

############
#  Backup  #
############

echo Backing up the dotfiles
cd 
[ -d $BACKUP ] || mkdir $BACKUP
[ -d $BACKUP/vimperator/plugin ] || mkdir -p $BACKUP/vimperator/plugin
#general dotfiles
for file in $INSTALL; do
    cp -ru --backup=t -L .$file $BACKUP$file 
done
#mplayer files
[ -d ~/.mplayer/ ] && cp --backup=t -L ~/.mplayer/* $BACKUP 2>/dev/null
#lxde files
[ -d ~/.config/openbox ] && cp --backup=t -L ~/.config/openbox/* $BACKUP 2>/dev/null

#############
#  INSTALL  #
#############

echo Installing dotfiles for $type
for file in $BASH; do
    ln -f -s dotfiles/bash/$file .$file
done

#VIM (nasty loop error... )
ln -f -s dotfiles/vim/vim/ .vim
ln -f -s dotfiles/vim/vimrc .vimrc

#If server exit
[[ "$type" == "server" ]] && exit 0

for file in $X; do
    ln -f -s dotfiles/X/$file .$file
done

for file in $WEB; do
    ln -f -s dotfiles/vimperator/$file .$file
done

for file in $TMUX; do
    ln -f -s dotfiles/tmux/$file .$file
done

[ -d ~/.mplayer/ ] || mkdir ~/.mplayer/
cd ~/.mplayer/
ln -f -s ~/dotfiles/mplayer/* .

[ -d ~/.config/openbox/ ] || mkdir -p ~/.config/openbox/
cd ~/.config/openbox/ 
ln -f -s ~/dotfiles/lxde/* .

#######################
#  UPDATE SUBMODULES  #
#######################
cd ~/dotfiles

echo Installing submodules
git submodule init

echo Updating submodules 
git submodule update  --init --remote

echo Install script Done!.
