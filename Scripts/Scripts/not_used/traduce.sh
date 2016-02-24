#!/bin/bash
# Traduce en base a google una palabra o un phrasal verb del ingles al castellano 
# o viceversa
# ARGUMENTOS
# Por defecddto traduce del ingles al español en caso de que no se indique como primer
# al comando la palabra 'es'
# Si se le pasa rae busca en el rae la palabra
# Implmentar la buscar en el diccionario de wordrefence y en el de oxford online
# Ejemplos:
#  traduce.sh 'draw up'
#  traduce.sh es redactar
#  traduce hit
#  traduce pr hit
# set -x
TEMP_FILE=/tmp/google-trans.$$
PHON_DIR=~/.traduce/phonetics
DICT_DIR=~/.traduce/dictionary
trap "rm -f ${TEMP_FILE}" 1 2 3 9 15
LANG1='en'
LANG2='es'
PAL="$1"
URL="http://www.google.com/dictionary?&hl=es&langpair=$LANG1|$LANG2&q=$PAL"

if [ "$1" == "es" ]; then
  LANG1=$1	
  LANG2='en'
  PAL="$2"
URL="http://www.google.com/dictionary?&hl=es&langpair=$LANG1|$LANG2&q=$PAL"
fi;

if [ "$1" == "rae" ]; then
  URL="http://buscon.rae.es/draeI/SrvltGUIBusUsual?LEMA=$2&TIPO_HTML=2"
lynx -dump --nolist "$URL" -useragent=Mozilla  > ${TEMP_FILE} > ${TEMP_FILE}
less ${TEMP_FILE} 
echo  
rm -f ${TEMP_FILE}
exit 0
fi;

if [ "$1" == "f" ]; then
   echo "$2" | festival --tts
exit 0
fi;


if [ "$1" == "pr" ]; then 
 if [ ! -d $PHON_DIR ]; then
   mkdir $PHON_DIR;
 fi

 if [ -e "$PHON_DIR/$2.mp3" ]; then
  mplayer $PHON_DIR/$2.mp3;
  mplayer $PHON_DIR/$2.mp3;
  mplayer $PHON_DIR/$2.mp3;
 else  
#  wget -A word.swf  -O /tmp/$2.swf "http://www.howjsay.com/index.php?word=$2&submit=Submit" 
# wget -qO- $(wget -qO- "http://www.m-w.com/dictionary/$2" | grep 'return au' | sed -r "s|.*return au\('([^']*)', '([^'])[^']*'\).*| http://media.merriam-webster.com/soundc11/\2/\1|") > $PHON_DIR/$2.mp3 && aplay $PHON_DIR/$2.mp3;
   wget -qO- $(wget -qO- "http://www.oxfordadvancedlearnersdictionary.com/dictionary/$2" | grep 'playSoundFromFlash' |  sed -r "s|.*playSoundFromFlash\('([^']*$2__gb[^']*)'.*| http://www.oxfordadvancedlearnersdictionary.com/\1|") > $PHON_DIR/$2.mp3  && mplayer $PHON_DIR/$2.mp3
 fi;
exit 0
fi;


 if [ ! -f "$DICT_DIR/$PAL.txt" ]; then
  lynx -dump --nolist "$URL" -useragent=Mozilla  > ${TEMP_FILE}
  cat ${TEMP_FILE} 2>/dev/null \
  | tail -n $((`wc -l ${TEMP_FILE} 2>/dev/null | \
  awk '{ print $1 ;}'`-10)) > "$DICT_DIR/$PAL.txt" 
  echo 
  rm -f ${TEMP_FILE}  
fi;
sed -i 's/r<lbd>/\/u\//' "$DICT_DIR/$PAL.txt"
sed -i 's/V":/3:/' "$DICT_DIR/$PAL.txt"
sed -i 's/A./a/' "$DICT_DIR/$PAL.txt"

less "$DICT_DIR/$PAL.txt"
