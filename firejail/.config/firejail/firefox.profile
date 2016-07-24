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
#
##not working! (disables all binaries!)
#private-bin python3 
#private-bin du
#private-bin killall 
#private-bin mplayer 

#You have to whitelist just the symlink dir
#and firejail whitelist the target dirs and files
whitelist ~/.mplayer
read-only ~/.mplayer


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

#
## from http://blog.swwomm.com/2015/11/sandboxing-firefox-with-firejail.html
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
blacklist /proc
blacklist /run
blacklist /sbin
blacklist /srv
blacklist /var
read-only /lib
read-only /lib64
read-only /usr
#warning
#blacklist /sys
#working properly
private-dev
#disable ssl graphic drivers ... needs debugging
#private-etc alternatives,firefox,fonts,hosts,localtime,nsswitch.conf,resolv.conf ssl pki
#private-etc hosts,passwd,mime.types,fonts/,mailcap,,xdg/,gtk-3.0/,resolv.conf,X11/,pulse/,gcrypt/,alternatives/
#
#include main profile
include /usr/local/etc/firejail/firefox.profile
