# vim: set filetype=sh :
# My bash aliases
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

#############
#  General  # 
############# 

#Possible endless loop with make -j
#nproc command also possible
(( $(getconf _NPROCESSORS_ONLN) > 2 )) && alias make='make -j $(( $(getconf _NPROCESSORS_ONLN)-1 ))'

#git aliases
alias gtb='git branch -a'
alias gtc='git commit -av'
alias gt1='git commit '
alias gts='git status'
alias gta='git add '
alias gtl='git log --graph --abbrev-commit --decorate --date=relative --all'
alias gtpush='git commit -a && git push'
alias gtpull='git pull --rebase'


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


needs(){ hash $1 2>/dev/null; return $?; }

#General
# To use the clipboard  from vim...
needs vimx && alias vi='vimx'
needs vim.gtk && alias vi='vim.gtk'
needs rmalias && alias rm='rmalias -v'
needs rmdiralias && alias rmdir='rmdiralias -v'
alias grep='grep --color=auto'
alias dgrep='grep --color=auto --exclude-dir=.git -rin '
alias cp="cp -v"
alias cpfolder='rsync --progress -rva'
alias tarc='tar -I lbzip2'
alias xargs='xargs -0'
alias open='xdg-open'

alias pgrep='pgrep -af'
alias tree='tree -CFpa'
alias gd='cd ~/dotfiles/'
alias gc='cd ~/Clones/'
alias gt='cd /tmp/'
alias tmux='history -w; tmux -u2'
alias df='df -h'


#############
#  Desktop  # 
############# 

needs smplayer && alias verflashgui="smplayer  ~/Descargas/videoFlash" 
needs fastboot && alias fastboot="fastboot  -i 0x1f3a" 
needs gpicview && alias fotos='gpicview'
alias mplayer-masvolumen='mplayer -softvol -softvol-max 300'
alias verflash="mplayer -fs ~/Descargas/videoFlash" 
alias verflashl="tail -f /tmp/youtube.log" 
alias spotify="~/Scripts/alternate_vbox.sh Spotify" 
alias webshare='python -m SimpleHTTPServer'


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

