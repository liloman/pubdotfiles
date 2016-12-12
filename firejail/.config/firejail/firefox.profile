# My custom profile for firefox


#Needs
# 1- Allow youtube-dl and block python
# 2- whitelist .mplayer


#For youtube-dl 
#
blacklist /sbin
#not working?
blacklist /bin

##Allow python for youtube-dl
noblacklist /usr/bin/python3*
noblacklist /usr/lib/python3*

#not working! (disables all binaries!)
#private-bin python3,du,killall,mplayer
#private-bin basename,uname,pidof,mkdir,cat,sed,bash,sh
#private-bin chmod,rm,readlink,rsync
#private-bin firefox,firejail,run-mozilla.sh

#You have to whitelist the symlink FILES
#and firejail whitelists the target FILES
#no working globbing 
whitelist ~/.mplayer/config
read-only ~/.mplayer/config
whitelist ~/.mplayer/input.conf
read-only ~/.mplayer/input.conf


#my settings
whitelist ~/Scripts/clean_firefox.sh 
read-only ~/Scripts/clean_firefox.sh
whitelist ~/Scripts/firefox_sync.sh 
read-only ~/Scripts/firefox_sync.sh
#It doesn't whitelist automatically everything inside
whitelist ~/Scripts/descarga.sh 
read-only ~/Scripts/descarga.sh
whitelist ~/Scripts/libnotify
read-only ~/Scripts/libnotify
#simple dir
whitelist ~/tests
read-only ~/tests

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

#include main profile
include /usr/local/etc/firejail/firefox.profile
