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

####################
#  Readline stuff  #
####################

###########
#A.helpers#
###########

#set current cmdnumber for prompt and for insert_relative_command_number
cmdNumber=0
#for search_substring_history functions
declare -ag arrayhistory
#not restore row when first substring search 
declare -g not_delete_under_ps1=0
#To show msgs below PS1
declare -gA msgs_below_ps1

#get the last commented command line
get_last_history_line() {
    #get "current command"
    local cmd=$(history 1)
    #and eliminate till first #
    cmd=${cmd#*#}
    [[ -z $cmd ]] && last_command_line=
    last_command_line=$cmd
}

append_to_history_line() {
    #remove last history entry 
    history -d $historyid
    #append to history line
    history -s "$@"
}

#Bash doesn't get into account of histcontrol and histignore with \#
#so you must roll on your on solution (reported to bash bug...) 
# and HISTCMD doesn't work outside of readline because they are different processes
# in bash 4.4 you sould be able to use prompt expansion echo ${PS1@P}
set_cmd_number() {
    local last=($(HISTTIMEFORMAT=; history 1))
    #get historyid
    historyid=${last[0]}
    #remove id
    local actual=${last[@]:1}
    local -a excl
    #if not equal,commented out command or history command
    # from $HISTCONTROL
    if [[ $pre_cmd != $actual ]]; then
        #Get exclusions
        IFS=":"; excl=($HISTIGNORE); unset IFS
        #Check exclusions
        for elem in "${excl[@]}"; do 
            [[ $elem* = $actual ]] && return
        done
        pre_cmd=$actual
        ((flaghistory!=1)) && ((cmdNumber++))
    fi
    flaghistory=0
}

#restore saved consolerow from save_current_row in ps1
restore_row() {
    #substract prompt_command lines
    tput cup $((CONSOLEROW-PROMPT_COMMAND_LINES)) 0
    #clean screen below PS1
     tput ed
}


#get current screen row to restore it after ctl-g functions
save_current_row() {
    local COL
    local ROW
    IFS=';' read -sdR -p $'\E[6n' ROW COL
    echo "${ROW#*[}"
}

#######
#B.fun#
#######

#Insert the relative command number from the actual
insert_relative_command_number() {
    [[ -z $last_command_line ]] && return
    local -a cmda=($last_command_line)
    #get last argument index
    local idx=$((${#cmda[@]}-1))
    #get last argument
    local arg=${cmda[$idx]}
    #substract the current command number with the destiny (last argument)
    if (( cmdNumber > arg )); then
        arg=!-$((cmdNumber - arg )):0 
    elif (( cmdNumber == arg )); then
        arg=!#:0 
    else
        add_restore_msg "error history line number not found" 
        arg=
    fi
    local write="${cmda[@]:0:$idx} $arg"
    #append to history line
    append_to_history_line "$write"
}

#reset substring search argument
reset_search_arg() {
    unset -v msgs_below_ps1["Enter Control-q to reset search"]
    add_restore_msg "Substring search was reset"
    bind -r "\C-q"
    currentSearchArg=
    show_msgs_below_ps1
}

#add a msg to show it bellow the PS1
add_restore_msg() {
    local msg=$1
    local fix=${2:-no}
    msgs_below_ps1[$msg]=$fix
    not_delete_under_ps1=1
}

#Show msgs from ctl-g functions below the PS1
show_msgs_below_ps1() {
    local fix=
    local msg=
    local found=0

    if ((not_delete_under_ps1)); then 
        #go below 
        tput cup $((CONSOLEROW-1)) 0
        for msg in "${!msgs_below_ps1[@]}"; do
            fix=${msgs_below_ps1["$msg"]}
            [[ $fix == no ]] && unset -v msgs_below_ps1["$msg"] || found=1
            #clean the line 
            tput el
            #should msg be deleted after x seconds?
            echo $msg 
        done
        #restore
        tput cup $((CONSOLEROW-2)) 0
        not_delete_under_ps1=$found
    fi
}

#Search forward/backward for a substring in the history and return it to the command line
#It doesn't work right with arguments with spaces "dir with spaces"
#More than enough for me use case
search_substring_history(){
    [[ -z $last_command_line ]] && return
    bind -x '"\C-q": reset_search_arg'
    local way=$1
    local -a cmda=($last_command_line)
    #get last argument index
    local idx=$((${#cmda[@]}-1))
    local arg=
    local write=
    local end=0
    local found=0

    #not active search
    if [[ -z $currentSearchArg ]]; then
        arrayhistory=()
        #get last argument
        arg=${cmda[$idx]}
        #echo "Indexing."
        #load search in arrayhistory
        while IFS= read -r lines;
        do
            readarray -t line <<<"$lines"
            #command contains 
            if [[ ${line[@]} == *$arg* ]]; then
                #command arg contains
                for elem in ${line[@]}; do 
                    if [[ $elem == *$arg* ]]; then
                        #unique elements, so you must do intensive 
                        for hay in ${!arrayhistory[@]} ; do
                            [[ ${arrayhistory[$hay]} == $elem ]] && found=1
                        done
                        ((!found)) && arrayhistory+=("$elem") 
                        found=0
                    fi
                done
            fi
        done < <(fc -nlr 1)

        add_restore_msg  "Enter Control-q to reset search" yes
        #and set the flag to not restore row the first time
        currentSearchArg=$arg
        currentSearchIdx=0

    else #active search
        if [[ $way == backward ]];then
            if (( currentSearchIdx < $(( ${#arrayhistory[@]}-1 )) )); then
                ((currentSearchIdx++))
            else
                end=1
            fi
        else #forward
            if (( currentSearchIdx > 0 )); then
                ((currentSearchIdx--))
            else
                end=1
            fi
        fi
    fi

    if ((!end)); then
        arg=${arrayhistory[$currentSearchIdx]}
        write="${cmda[@]:0:$idx} $arg"
    else
        write="${cmda[@]} "
    fi
    #append to history line
    append_to_history_line "$write"
}

###########
# General #
###########


#Set the ps1 bash prompt with exit status and command number
show_ps1() {
    local lastExit=$? # Should come first...
    #save current console row to restore it after control-g functions
    CONSOLEROW=$(save_current_row)
    local Blue='\[\e[01;34m\]'
    local White='\[\e[01;37m\]'
    local Red='\[\e[01;31m\]'
    local Green='\[\e[01;32m\]'
    local Reset='\[\e[00m\]'
    #Copy & Paste from any unicode table... 
    local arrow=$(printf "%s" ➬)

    #set historyid and cmdNumber to work with the readline stuff on B.Fun
    set_cmd_number

    error="${White}$lastExit"
    (( $lastExit )) && error="${Red}$lastExit"

    #Print my command history number and error number
    PS1=" ${Blue}[${Reset}C:${White}$(echo $(($cmdNumber)))${Reset}-E:${error}${Blue}:${Red}\w"

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
  clean() { 
      echo -n "cleaning"
      \rm -f /dev/shm/algo ~/algo 
      echo "."
  }
trap clean INT
local algo=
read -p "Dame algo:" -se algo
echo $algo | sha512sum | base64 > /dev/shm/algo
unset algo
echo "."
ln -s /dev/shm/algo ~/algo
#sleep execute || on INT signal
sleep 30 && clean || clean
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

