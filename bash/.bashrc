# vim: set filetype=sh :
# My bashrc for non-login shells
# see /usr/share/doc/bash/examples/startup-files for examples
# Copyright © 2015 liloman
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

#Disable <C-s>(stop) and <C-q>(start) on terminal. To use <C-s> on vim (to save a file)
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
PROMPT_COMMAND='show_ps1;list_dir_stack'

HISTSIZE=50000
HISTFILESIZE=50000
#Maybe I should rework this to make it dinamic again...
HISTFILE=~/.bash_historys/history_
#Ignore from history dumb commands as duplicates and exits
HISTIGNORE="&:exit"

# to work properly with shopt -s extglob  (ls -d .*)
GLOBIGNORE=.:..

#Enable dir stack behavior
DIRSTACK_ENABLED=true
#Maximum dir stack size
DIRSTACK_LIMIT=8
# Full paths to exclude from dir stack separated by colon
DIRSTACK_EXCLUDE="/foobar:$HOME"


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
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
#-e quit at 2 eof, -I case insensitive search
#-r raw control displayed (colors), -M long prompt
# -X dont send de/initialization strings to the terminal
# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(lesspipe)"

#Default editor
export VISUAL=vim
export EDITOR="$VISUAL"
export GIT_EDITOR=vim
#Let's use most 
export PAGER="most" 
# to open  the manpages in a brower with man -H command :)
export BROWSER="firefox" 
# to show file, line and func when set -x
export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
#show messages in english
export LANG=C




###########
#  Binds  #
###########

#see .inputrc :)

# Interesting autocompletions
#Complete filename against complete history! :D
bind -m vi-insert "\C-n":dynamic-complete-history
#Complete filename/commands/... same as TAB
bind -m vi-insert "\C-p":menu-complete

#Custom mappings ...
#Should clean leaving prompt_command...
#bind -x '"\C-l":/bin/clear'

#Autocomplete !$,!*,!!,!cat ... before of space ... :)
bind Space:magic-space

###########
#  Files  #
###########

# PATH modified in ~/.bash_profile

#Z script to get the most common directories and so on
#git clone https://github.com/rupa/z 
if [[ -f ~/Clones/z/z.sh ]]; then
    . ~/Clones/z/z.sh
    _Z_DATA=$HOME/.zs/.z
    #no clobber my $PROMPT_COMMAND
    _Z_NO_PROMPT_COMMAND=true
fi

# Alias definitions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Function definitions
[[ -f ~/.bash_functions ]] && . ~/.bash_functions

#Enable Autocompletions 
[[ -f /usr/share/bash-completion/bash_completion ]] && 
            . /usr/share/bash-completion/bash_completion

#To work with git
source /usr/share/doc/git-core-doc/contrib/completion/git-completion.bash
source /usr/share/doc/git-core-doc/contrib/completion/git-prompt.sh

# added by travis gem
[[ -f /home/charly/.travis/travis.sh ]] && source /home/charly/.travis/travis.sh

