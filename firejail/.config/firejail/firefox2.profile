# My custom profile for firefox
include /usr/local/etc/firejail/firefox.profile


#my settings
blacklist /mnt/ 
whitelist ~/.vimperator/plugin 
whitelist ~/Scripts/clean_firefox.sh 
whitelist ~/Scripts/firefox_sync.sh 
#descarga.sh all cmds???
whitelist ~/Scripts/descarga.sh 
# whitelist /usr/bin/mplayer
# whitelist /usr/bin/xscreensaver-command 
# whitelist /usr/bin/youtube-dl
# whitelist /usr/bin/du
# whitelist /usr/bin/mplayer 
# whitelist /usr/bin/nohup
# whitelist /usr/bin/killall
# whitelist /usr/bin/sleep

noblacklist /usr/bin/python3


# from http://blog.swwomm.com/2015/11/sandboxing-firefox-with-firejail.html
noblacklist /run/dbus
noblacklist /run/resolvconf
noblacklist /run/user
noblacklist /var/cache/hald
noblacklist /var/run
blacklist /boot
blacklist /cdrom
blacklist /lost+found
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /proc
blacklist /run/*
blacklist /sbin
blacklist /srv
#blacklist /sys
blacklist /usr/sbin
blacklist /var/*
private-dev
private-etc alternatives,firefox,fonts,hosts,localtime,nsswitch.conf,resolv.conf
read-only /bin
read-only /lib
read-only /lib64
read-only /usr

