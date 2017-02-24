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
alias gt1='git commit -v'
alias gts='git status'
alias gta='git add '
alias gtl='git log --graph --abbrev-commit --decorate --date=relative --all'
alias gtpush='git commit -av && git push'
alias gtpull='git pull --rebase'
alias gtca='git commit -v --amend'


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
alias search='grep --color=auto --exclude-dir=.git -Rin '
alias cp="cp -v"
alias cpfolder='rsync --progress -rva'
alias tarc='tar -I lbzip2'
alias xargs='xargs -0'
alias open='xdg-open'
alias free='free -h'

needs ptree && alias pgrep='echo Did you mean ptree?' || alias pgrep='pgrep -af'
alias tree='tree -CFpa'
alias gd='cd ~/dotfiles/'
alias gc='cd ~/Clones/'
alias gt='cd /tmp/'
alias tmux='history -r; tmux -u2'
alias df='df -h'
alias dmesg='dmesg -HPku'
alias fbash='env -i  bash --norc --noprofile +o history'

needs timew && alias twt='timew work today'
needs timew && alias tww='timew work :week'

#############
#  Desktop  # 
############# 

needs smplayer && alias verflashgui="smplayer  ~/Descargas/videoFlash" 
#for the tablet (fastboot reboot when boot-looped)
needs fastboot && alias fastboot="fastboot  -i 0x1f3a" 
needs gpicview && alias fotos='gpicview'
needs mplayer && alias mplayer='mplayer -use-filename-title -fs'
needs mplayer && alias mplayer-masvolumen='mplayer -softvol -softvol-max 900'
needs mplayer && alias verflash="mplayer-masvolumen -fs /tmp/videoFlash" 
alias verflashl="tail -f /tmp/youtube.log" 
alias notas='vi ~/OPOS/Ingles/thesoundofenglish/notas.txt'
alias webshare='python -m SimpleHTTPServer'
alias bajaurl='wget -m -np -nd -p '

#Load alias and its autocompletition 
if needs pomodoro-client.py; then
    alias pc='pomodoro-client.py '
    [[ -e ~/.local/share/bash-completion/completions/pomodoro-client.py ]]
    #load _pomodoro-client.py
    . ~/.local/share/bash-completion/completions/pomodoro-client.py 
    complete -F _pomodoro-client.py pc
fi

alias kspotify='pid=$(ptree spotify | grep Watchdog ) && kill ${pid#*,}'
#from: pip install grip --user
needs grip && alias markdown-view='grip -b '
#from: wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
needs gh-md-toc && alias markdown-generate-toc='gh-md-toc'


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
# alias spotify="~/Scripts/alternate_vbox.sh Spotify" 
# needs VBoxManage && alias vbsound='VBoxManage controlvm Spotify acpipowerbutton && sleep 20 && VBoxManage startvm Spotify'

unset -f needs
