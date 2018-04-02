# My custom profile for firefox

#Needs
# 1- Allow youtube-dl and block python

##Allow python for youtube-dl
noblacklist /usr/bin/python3*
noblacklist /usr/lib/python3*

#Working?
#private-bin python3,python3.5,du,killall,mplayer,basename,uname,pidof,mkdir,cat,sed,bash,sh,chmod,rm,readlink,rsync,firefox,firejail,run-mozilla.sh,lxterminal,ls,env,sleep,wget,youtube-dl,nohup,mv,touch,tar,ln,notify-send,mupdf

#You have to whitelist the symlink dir
#and firejail whitelists the target FILES
# GOTCHAS:
# Globbing doesn't work ! 
# DONT END DIRS WITH /  !
# When used a target file it doesn't whitelist the origin dir when it's a symlink !
# reported: https://github.com/netblue30/firejail/issues/1388

# noblacklist this case first otherwise target dir will be mount 
# as nfsnobody:nfsnobody therefore without permissions
noblacklist ~/.mplayer
#business as usual then
whitelist ~/.mplayer
read-only ~/.mplayer

#my settings
# whitelist ~/Scripts
# read-only ~/Scripts
whitelist ~/Scripts/clean_firefox.sh 
read-only ~/Scripts/clean_firefox.sh
whitelist ~/Scripts/firefox_sync.sh 
read-only ~/Scripts/firefox_sync.sh
whitelist ~/Scripts/link_indexedDB.sh 
read-only ~/Scripts/link_indexedDB.sh


#It doesn't whitelist automatically everything inside
whitelist ~/Scripts/descarga.sh 
read-only ~/Scripts/descarga.sh
whitelist ~/Scripts/libnotify
read-only ~/Scripts/libnotify

whitelist ~/Clones/third/firefoxQuantum
read-only ~/Clones/third/firefoxQuantum

#simple dir
whitelist ~/tests
read-only ~/tests
whitelist ~/OPOS/apuntes/Varios/file++++home+charly+tests+index.html

#no dbus access  (not working ?)
#blacklist /run/user/1000/bus
#prevent lxterminal connecting to an existing lxterminal session 
blacklist /tmp/.lxterminal-socket*

##
### from http://blog.swwomm.com/2015/11/sandboxing-firefox-with-firejail.html
noblacklist /run/dbus
noblacklist /run/resolvconf
noblacklist /run/user
noblacklist /var/cache/hald
noblacklist /var/run
blacklist /boot
blacklist /lost+found
blacklist /media
blacklist /mnt
blacklist /opt
#not working
#blacklist /proc
blacklist /sbin
blacklist /srv
## not working anymore (network stop working)
# blacklist /var
read-only /lib
read-only /lib64
read-only /usr
#for pulseaudio
#noblacklist /run/user/1000/pulse
#noblacklist not working :(
#blacklist /run
#
#warning
#blacklist /sys
#working properly
private-dev
#disable ssl graphic drivers ... needs debugging
#private-etc alternatives,firefox,fonts,hosts,localtime,nsswitch.conf,resolv.conf ssl pki
#private-etc hosts,passwd,mime.types,fonts/,mailcap,,xdg/,gtk-3.0/,resolv.conf,X11/,pulse/,gcrypt/,alternatives/
#

# private-tmp not working for my firefox setup  (cache in /tmp)
# or need fix the script to work with firejail --get
# the ignore must be first to the include
ignore private-tmp

noblacklist ~/vimperatorrc
noblacklist ~/vimperator
whitelist ~/vimperatorrc
whitelist ~/vimperator

#include main profile
include /usr/local/etc/firejail/firefox.profile
