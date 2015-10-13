#!/bin/bash
BACKUP=dotfiles_backup
BASH=" bashrc inputrc bash_profile bash_logout git-completion.bash git-prompt.sh ctags"
X=" Xresources Xdefaults Xmodmap"
TMUX=" tmux.conf"
VIM=" vim vimrc"
WEB=" vimperatorrc"
__ScriptVersion="0.1"

function usage ()
{
cat <<- EOT

  Usage :  $0 [options] [--]

  Options:
  -h|help       Display this message
  -v|version    Display script version
  -u|user       Full version  (BASH,VIM,TMUX,WEB)
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
[[ -z "$type" ]] && echo $0 need arguments. Execute $0 -h for help. &&  exit 0

[[ "$type" == "user" ]] && INSTALL=$BASH$VIM$WEB$X$TMUX
[[ "$type" == "server" ]] && INSTALL=$BASH$VIM 

echo $type $INSTALL
#Backup first
cd ~
mkdir $BACKUP
for file in $INSTALL; do
    mv .$file $BACKUP
done

for file in $BASH; do
    ln -s dotfiles/bash/$file .$file
done

for file in $VIM; do
    ln -s dotfiles/vim/$file .$file
done

#If server exit
[[ "$type" == "server" ]] && exit 0

for file in $X; do
    ln -s dotfiles/X/$file .$file
done

for file in $WEB; do
    ln -s dotfiles/vimperator/$file .$file
done

for file in $TMUX; do
    ln -s dotfiles/tmux/$file .$file
done

cd dotfiles

echo Installing submodules
git submodule --init --recursive

echo Updating submodules 
git submodule update  --init --remote
