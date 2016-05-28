# vim: set filetype=sh :
# My bashrc for non-login shells
# see /usr/share/doc/bash/examples/startup-files for examples
# Copyright © 2016 liloman
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#

# If not running interactively, don't do anything
[[ -z $PS1 ]] && return

###################
#  Shell options  #
###################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Fix cd spelling
shopt -s cdspell
# Save multiline commands in one line
shopt -s cmdhist
# Dont delete history
shopt -s histappend
# Regexp in bash prompt
shopt -s extglob
#Disable report expansion errors (lot of problems...)
#like wget http://url or tab completition
shopt -u failglob
#Allow dot expansion by globbing
shopt -s dotglob
#Allow ** globbing
shopt -s globstar

#Disable <C-s>(stop) and <C-q>(start) on terminal. To use <C-s> on vim (to save file)
stty stop undef
stty start undef
#Disable control flow completely and press any key to start
stty -ixon -ixoff ixany

#Disable caps bloq  (needs work)
# setxkbmap -option ctrl:nocaps
#xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

#######################
# INTERNAL VARIABLES  #
#######################

KERNEL=$(uname -r)
TTY=$(tty)
PROMPT_COMMAND='show_ps1'

HISTSIZE=50000
HISTFILESIZE=50000
#Maybe I should rework this to make it dinamic again...
HISTFILE=~/.bash_history
#Ignore from history duplicate commands and exits
HISTIGNORE="&:exit"
#Store history with timestamp
HISTTIMEFORMAT='%F %T '

# to work properly with shopt -s extglob  (ls -d .*)
GLOBIGNORE=.:..


###################
#  Stderr in red  #
###################
# exec 9>&2
# exec 8> >(
# while IFS= read -r line || [[ -n $line ]]; do
#     echo -e "\[\e[00;31m\]${line}\[\e[00m\]"
# done
# )
#
# function undirect(){ exec 2>&9; }
# function redirect(){ exec 2>&8; }
# trap "redirect;" DEBUG
# PROMPT_COMMAND+='undirect;'

########################
#  EXPORTED VARIABLES  #
########################

# don't put duplicate lines in the history.
export HISTCONTROL=ignoredups
#Default vagrant provider to virtualbox otherwise libvirt
export VAGRANT_DEFAULT_PROVIDER=virtualbox

#less options applied
export LESS=" -eIRMX " 
#less colored when possible... :S
#needs customs cases...
[[ -f /usr/bin/src-hilite-lesspipe.sh ]] && export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
#-e quit at 2 eof, -I case insensitive search
#-r raw control displayed (colors), -M long prompt
# -X dont send de/initialization strings to the terminal
# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(lesspipe)"

needs(){ hash $1 2>/dev/null; return $?; }

#Default editor
needs vim && { 
export EDITOR=vim
export GIT_EDITOR=$EDITOR
export VISUAL=$EDITOR
}

#Let's use most 
needs most && export PAGER="most" 
# open  the manpages in a brower with man -H command :)
needs firefox && export BROWSER="firefox" 
# show file, line and func when set -x
export PS4='(${BASH_SOURCE}:${LINENO})(${FUNCNAME[0]}): '
#show messages in english with UTF-8 (powerline...)
export LANG=C.utf8
#Fix broken lxsession config dirs
export XDG_CONFIG_DIRS=$HOME/.config

export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig/"

[[ $TERM == xterm ]] && TERM=xterm-256color


#Export path to systemd user units 
systemctl --user set-environment PATH=$PATH


###########
#  Binds  #
###########

#see ~/.inputrc for all the power! (bash surround...) o_O

#Custom mappings ...
#Should clean leaving my prompt_command...
#bind -x '"\C-l":/bin/clear'

#Autocomplete !$,!*,!!,!cat ... after space ... :)
# bind Space:magic-space
#Don't execute history autocompletions but print it. Better than magic-space
shopt -s histverify

###########
#  Files  #
###########

# PATH modified in ~/.bash_profile

#source a filepath and declare variables
import(){
    #To work with file expansion
    if [[ -f $(echo $1) ]]; then
        . $1
        shift
        for arg; do
            eval $arg
        done
    fi
}


#Load dir stack plugin
import  ~/Clones/dirStack/dirStack.sh DIRSTACK_EXCLUDE+=":$HOME/dotfiles"

#Z script to get the most common directories and so on
#  https://github.com/rupa/z 
import ~/Clones/z/z.sh _Z_DATA=$HOME/.zs/.z _Z_NO_PROMPT_COMMAND=true

# load definitions before aliases to work with custom aliases
import ~/.bash_functions

# Function definitions
import ~/Scripts/libnotify

# Alias definitions
import ~/.bash_aliases

#Enable Autocompletions 
import /usr/share/bash-completion/bash_completion 

#To work with git 
import /usr/share/doc/git-core-doc/contrib/completion/git-completion.bash
import /usr/share/doc/git-core-doc/contrib/completion/git-prompt.sh

# added by travis gem
import ~/.travis/travis.sh 

#tmuxinator
import /usr/share/gems/gems/tmuxinator*/completion/tmuxinator.bash

#delete import function
unset -f import needs
