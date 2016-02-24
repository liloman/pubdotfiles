#!/bin/bash

FILE=Backup.tar.gpg
# Hace el backup 
cd ~
tar cpf - .xpdfrc .moc/ Scripts/ Documentos/ .bash* .vim* .mplayer/ .vimperator .traduce/ \
.config/ .macros-xmacro/ GNUstep .tkremindrc .wmakerconf/  .xbin* \
  | gpg -c > ~/Dropbox/Dropbox/Backup/$FILE
