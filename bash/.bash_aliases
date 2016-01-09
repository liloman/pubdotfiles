# vim: set filetype=sh :
# My bash aliases
# Copyright © 2015 liloman
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

#############
#  General  # 
############# 

#Possible endless loop with make -j
#nproc command also possible
alias make='make -j $(( $(getconf _NPROCESSORS_ONLN)-1 ))'

#git aliases
alias gtb='git branch -a'
alias gtc='git commit -a'
alias gt1='git commit '
alias gts='git status'
alias gta='git add '
alias gtl='git log --graph --abbrev-commit --decorate --date=relative --all'
alias gtpush='git commit -a && git push'


# enable color support of ls 
eval "`dircolors -b`"
#handy ls aliases
LS_COMMAND="/bin/ls -Fh --color=auto"
#normal listing 
alias ls='$LS_COMMAND -C'
#extended column listing sorted by name by default
alias lc='$LS_COMMAND -CA'
#extended flat listing sorted by name by default
alias ll='$LS_COMMAND -lA'


#General
# To use the clipboard  from vim...
alias vi='vimx'
alias grep='grep --color=auto'
alias cp="cp -v"
alias cpfolder='rsync --progress -rva'
alias tarc='tar -I lbzip2'
alias xargs='xargs -0'
alias open='xdg-open'
alias pgrep='pgrep -aw'
alias tree='tree -CFa'
alias rm='rmalias -v'
alias rmdir='rmdiralias -v'
alias gd='cd ~/dotfiles/'
alias gc='cd ~/Clones/'
alias gt='cd /tmp/'
alias tmux='tmux -u2'
alias df='df -h'


#############
#  Desktop  # 
############# 

alias fotos='geeqie'
alias fotos2='feh -rFd'
alias mplayer-masvolumen='mplayer -softvol -softvol-max 300'
alias verflash="mplayer -fs ~/Descargas/videoFlash" 
alias verflashgui="smplayer  ~/Descargas/videoFlash" 
alias verflashl="tail -f /tmp/youtube.log" 
alias spotify="alternateVBox Spotify" 
alias webshare='python -m SimpleHTTPServer'
alias fastboot="fastboot  -i 0x1f3a" 


#################
#  Old aliases  # 
################# 

#Show selinux context
#alias ps='ps -Z'
#alias activar-tvout='sudo xrandr --output TV --mode 1024x768 --set TV_FORMAT PAL'
#alias pega_seleccion='xsel -o -p'
#alias pega_clipboard='xsel -o -b'
# #alias mocp='(nohup $HOME/Scripts/lastfm-moc.sh >/dev/null &); mocp'
# alias genera_iso='genisoimage -J -r -o '
# alias graba_iso='brasero'
# alias lista_iso='isoinfo -f -R -i'
# # alias graba_dvd='growisofs -dvd-compat -Z /dev/hda'
# alias cambia_fondo='wmsetbg --center --maxscale "$(ls ~/.wallpapers/* | shuf -n1)"'
# alias identa-c='indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl'
# alias suspender='sudo s2ram --force -a 3'

