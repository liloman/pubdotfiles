# vim: set filetype=sh :
# My bash functions
# Copyright © 2016 liloman
#
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, see <http://www.gnu.org/licenses/>.

###########
# General #
###########

#Set the ps1 bash prompt with exit status and command number
set_ps1() {
    local Blue='\[\e[01;34m\]'
    local White='\[\e[01;37m\]'
    local Red='\[\e[01;31m\]'
    local Green='\[\e[01;32m\]'
    local Reset='\[\e[00m\]'
    #Copy & Paste from any unicode table... 
    local arrow=$(printf "%s" ➬)

    error="${White}$lastExit"
    (( $lastExit )) && error="${Red}$lastExit"

    #Print my command history number and error number
    PS1=" ${Blue}[${Reset}C:${White}$(echo $(($cmdnumber)))${Reset}-E:${error}${Blue}:${Red}\w"

    # Reset the text color to the default at the end.
    PS1+="]${Green}${arrow}${Reset}"
}


#Show the size of something
#maybe rework with tree or alike
tam() { du -hs "$@" | sort -h; }

#show the top 10 dir sizes
tamtop() { find "$@" -type d -exec du -hs {} + | sort -rhu | head -n 10; }

#Print octal symbol ready to be used in bash 
# or just use printf %s :D
#Copy & Paste from any unicode table... 
get_octal() {
    local dump=$(od -t o1 <<< '$1')
    read -r _ a b c _ <<< "$dump"
    echo -n "\\$a\\$b\\$c"
    echo -e " ($1)"
}


bak() {
    local arg="$1" ; shift
    [[ -e $arg ]] || { echo "file/dir:$arg must exist"; return 1; }
    arg=${arg%/}
    local bak="$arg.bak"
    if [[ ${arg: -4} != .bak ]]; then 
        \cp -r "$arg" "$bak" && \
            echo "Copied $arg to $bak"
    else 
        bak="${arg%.bak}" && \
            \rm -rf "$bak" && \
            \mv "$arg" "$bak" && \
            echo "Moved $arg to $bak"
    fi
}

#Add new executable symlink to ~/.local/bin dir
lbin() {
    local dest=~/.local/bin/
    for arg; do
        local file="$(realpath "$arg" 2>/dev/null)"
        [[ -n $file ]] || { echo "Must pass a valid file"; return; }
        [[ ! -d $dest ]] && mkdir -p $dest
        ln -sfv  $file $dest
    done
}

#Remove executable symlink from ~/.local/bin dir
rbin() {
    local dest=~/.local/bin/
    for arg; do
        rm -v $dest/$arg
    done
}

#Return the process tree of a command/pid
#-l to long output
#-s to go till pid 1
ptree() {
    [[ -z $1 ]] && { echo "You must pass a command name"; return 1; }
    local arg="-aSpuU" 
    local kpid=

    #Get extra pstree arguments
    OPTIND=1 #important reset!!
    while getopts ":AlcsgGZnNhk:" opt
    do
        case $opt in 
            A|l|c|s|g|G|Z|n|N|h)  
                arg+=" -$opt"
                ;;
            k)  
                kpid=$OPTARG
                ;;
            \?)  echo -e "Option does not exist : $OPTARG\n"; return 1
                ;;
            :)  echo -e "Option $OPTARG requires an argument \n"; return 1
        esac 
    done
    shift $(($OPTIND-1))

    show_tree() {
        local -a pids
        local ppid
        local i=1
        #Check if pid
        [[ $1 =~ ^[0-9]+$ ]] && pids=($1) || pids=($(\pgrep -f $1))

        for pid in ${pids[@]}; do
            #trim ppid 
            read ppid <<< $(ps hoppid $pid)
            if [[ -n $kpid ]]; then
                if (( i++ == kpid )); then
                    echo -n "Killing [k:$kpid] " 
                    [[ " ${pids[@]} " =~ " $ppid " ]] || \pstree $arg -H $pid $pid 
                    kill -9 $pid && echo "Done!"
                fi
            else
                #Show index to kill command
                echo -n "[k:$((i++))] "
                # if not parent on pids then pstree it
                [[ " ${pids[@]} " =~ " $ppid " ]] || \pstree $arg -H $pid $pid 
            fi
        done 
    }

    (( $# == 0 )) && echo "Needs and command name"
    for com;do
        show_tree $com
    done
}

repeat() {
    local number=$1; shift
    for n in $(seq $number); do
        $@
    done
}


#Remove a file form git history
git_rm_history() {
    [[ -z $1 ]] && { echo "You must pass a dir name to delete"; return 1; }
    git filter-branch -f --tree-filter 'rm -rf $1/' HEAD
}


algo() {
  local sec=180
  local algo=
  local file=/dev/shm/algo.key
  clean() { 
      echo -n "removing $file"
      \rm -f $file
      echo "."
  }
trap clean INT
read -p "Dame algo:" -se algo
echo $algo | sha512sum | base64 > $file
unset algo
echo " "
echo "Waiting $sec seconds"
inotifywait -q -t $sec -e close $file
clean 
}

#WIP ...
#need some time to finish it
search2() {
local path=${2:-"."}
[[ -z $1 ]] && { echo "You need a pattern at least"; return; }
local pattern=${1}
#it needs to use parallel, xargs or neither
find $path -type f -print0 | parallel -k -j+1 -n 1000 -m  grep --color=auto --exclude-dir=.git -in $pattern {}

}

#Insert a new symlink into Scripts dir
script_insert() {
    local new=$1
    [[ -x $new ]] || { echo "$new doesn't exist or not executable"; return; }
    mv $new ~/dotfiles/Scripts/Scripts/
    #get just the file name 
    local file=${new##*/}
    cd ~/Scripts
    #Needs to be done relative to work with stow
    ln -s ../dotfiles/Scripts/Scripts/$file .
    echo "symlink for $file created."
    ls -l $file
}

#Remove a symlink from Scripts dir
script_remove() {
    local file=${1##*/}
    #remove the file
    [[ -e ~/Scripts/$file ]] && echo "$file removed from Scripts"
    rm -f ~/Scripts/$file
    rm -f ~/dotfiles/Scripts/Scripts/$file 
}

#Insert a new app for the lxde menus
icon_insert() {
    local file=${1##*/}.desktop
    local lapp=~/.local/share/applications
    local app=/usr/share/applications/$file
    #check for app
    [[ -e $app  ]] || { echo "$app doesn't exist"; return; }
    [[ -d $lapp ]] || mkdir -p $lapp
    cp  $app $lapp
    cd $lapp
    echo "Edit $file then execute 'lxpanelctl restart' to update the menus"
}

#Create an executable file
e() { install -bvm 755 /dev/null $1 ; vimx $1; } 


#Remove hint from asyncBash (alt + h/e)
dhint() {
    # path="~/something" isn't expanded ??
    local path=~/.local/hints
    local hint=$path/$1.txt
    [[ -f $hint ]] && rm -v $hint || echo "$hint doesn't exist"
}


#############
#  Desktop  #
#############



#Cut videos from start to end duration. See join_video in Scripts also
cut_video() {
    local video=$1
    local start=$2
    local end=$3
    local dest=${4:-"dest.mp4"}
    [[ -z $video ]] && { echo "You need to pass a video file"; return; }
    [[ -z $start ]] && { echo "You need the start time, ie  00:03:1"; return; }
    [[ -z $end ]] && { echo "You need the end time, ie 2 seconds"; return; }
    ffmpeg -i "$video" -ss $start -t $end -async 1 -strict -2 "$dest"
}

#Launch mplayer with a playlist with or without loop (0 for infinite)
mp() {
    local list=${1:-"playlist"}
    local loop=${2:-1}
    ${BASH_ALIASES[mplayer]} -playlist $list -loop $loop
}


#Let's use vim to read manpages right!
# function man() { vim -c "Man $*" -c "silent! only";  }

