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

show_ps1() {
    local lastExit=$? # Should come first...
    local Blue='\[\e[01;34m\]'
    local White='\[\e[01;37m\]'
    local Red='\[\e[01;31m\]'
    local Green='\[\e[01;32m\]'
    local Reset='\[\e[00m\]'
    #Copy & Paste from any unicode table... 
    local arrow=$(printf "%s" ➬)


    error="${White}$lastExit"
    (( $lastExit )) && error="${Red}$lastExit"

    #Print command history and error number
    PS1=" ${Blue}[${Reset}C:${White}\#${Reset}-E:${error}"

    # Reset the text color to the default at the end.
    PS1+="${Blue}:${Red}\w]${Green}${arrow}${Reset}"
}


#Show the size of something
#maybe rework with tree or alike
tam() { du -hs "$@" | sort -h; }

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
                (( i++ == kpid )) && { echo "Killing $pid"; kill -9 $pid; }
            else
                #Show index to kill command
                echo -n $((i++))-
                # if not parent on pids then pstree it
                [[ " ${pids[@]} " =~ " $ppid " ]] || \pstree $arg -H $pid $pid 
            fi
        done 
    }

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

#############
#  Desktop  #
#############



#Listen to several radios
radios(){
    [ "$1" = "xfm" ] && mplayer http://mediasrv-sov.musicradio.com/XFMLondon
    [ "$1" = "virgin" ] && mplayer http://www.smgradio.com/core/audio/ogg/live.pls?service=vrbb
    [ "$1" = "capital" ] && mplayer http://mediasrv-the.musicradio.com/CapitalRadio
    [ "$1" = "bbcworld" ] && mplayer -playlist  http://bbc.co.uk/radio/worldservice/meta/tx/nb/live_infent_au_nb.asx
    [ "$1" = "bbc1" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/r1.asx
    [ "$1" = "bbc1x" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/r1x.asx
    [ "$1" = "bbc2" ] && mplayer -softvol -softvol-max 200 -playlist  http://bbc.co.uk/radio/listen/live/r2.asx
    [ "$1" = "bbc3" ] && mplayer -softvol -softvol-max 200 -playlist  http://bbc.co.uk/radio/listen/live/r3.asx
    [ "$1" = "bbc4" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/r4.asx
    [ "$1" = "bbc5" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/r5.asx
    [ "$1" = "bbc6" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/r6.asx
    [ "$1" = "bbcman" ] && mplayer -playlist  http://bbc.co.uk/radio/listen/live/bbcmanchester.asx
    [ "$1" = "vaughan" ] && mplayer http://server01.streaming-pro.com:8012 
    [ "$1" = "radio3" ] && mplayer -cache 500 -playlist http://rtve.stream.flumotion.com/rtve/radio3.mp3.m3u
    [ "$1" = "folk-eu" ] && mplayer http://www.live365.com/play/wumb919fast
    [ "$1" = "folk" ] && mplayer -cache 500 -playlist http://public.wavepanel.net/3LACLKLS7UVKONE4/listen/m3u
    # alias folkradio_graba='mplayer -cache 500 http://www.live365.com/play/wumb919fast -ao pcm:file=radio.wav -vo null -vc null'
    #FRANCE
    [ "$1" = "nrj" ] && mplayer mms://vipnrj.yacast.fr/encodernrj
    [ "$1" = "rtl" ] && mplayer http://streaming.radio.rtl.fr/rtl-1-44-96
    [ "$1" = "rtl2" ] && mplayer http://streaming.radio.rtl.fr/rtl2-1-44-96
    [ "$1" = "europe2" ] && mplayer mms://vipmms9.yacast.fr/encodereurope2
    [ "$1" = "fip" ] && mplayer http://viphttp.yacast.net/V4/radiofrance/fip_hd.m3u
    [ "$1" = "franceculture" ] && mplayer http://viphttp.yacast.net/V4/radiofrance/franceculture_hd.m3u
    [ "$1" = "franceinter" ] && mplayer http://viphttp.yacast.net/V4/radiofrance/franceculture_hd.m3u
    [ "$1" = "lemouv" ] && mplayer http://viphttp.yacast.net/V4/radiofrance/lemouv_hd.m3u
    echo "Posibles opciones: xfm virgin capital bbcworld bbc1 bbc1x bbc2 bbc3 bbc4 bbc5 bbc6 vaughan radio3 folk-eu folk rtl rtl2 nostalgie europe2 (broken links galore) "
}


#Let's use vim to read manpages right!
# function man() { vim -c "Man $*" -c "silent! only";  }

