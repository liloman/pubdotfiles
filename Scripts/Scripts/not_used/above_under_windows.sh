#!/bin/bash
# Pone detras o delante la ventana actual 
# con la tecla windows + tab y se quita con windown + shift + tab
# Se guarda un fichero en /tmp con:
# Una linea por escritorio con esta opcion activada con escritorioid windowid tituloVentana
# Lo primero que se hace es buscar si para el escritorio actual existe alguna regla
#set -x
# si existe se aplica, sino se crea

########
#TODO
# Mirar la variable FOCUS_WINDOWS que no existe y se usa al final del script ...
#########

ACTUAL_WINDOW=$(wmctrl -a :ACTIVE: -v 2>&1 | grep window | cut -d' ' -f 3)
ACTUAL_WORKSPACE=$(wmctrl -d | grep \* | cut -d' ' -f1)
ACTUAL_TITULO=$(wmctrl -l | grep $ACTUAL_WINDOW | cut -d' ' -f5-)
FICHERO=/tmp/.wm_ctrl

# ARGMENTOS ESTADO
function taskbar(){
    if [ "$1" == "abajo" ]
    then # Feisimo pero es lo que se me ocurre ahora mismo
      for TASKBAR_WINDOW in  $(wmctrl -l | grep "$ACTUAL_WORKSPACE $(hostname)" | grep -v Emperador | cut -d' ' -f1); do
        wmctrl -v -i -r $TASKBAR_WINDOW -b add,skip_taskbar
      done;      
      while read TASKBAR_WINDOW;  do
        wmctrl -v -i -r $TASKBAR_WINDOW -b remove,skip_taskbar
      done < <(grep ^$ACTUAL_WORKSPACE $FICHERO | cut -d' ' -f2)
    fi;
    if [ "$1" == "arriba" ]; then
      for TASKBAR_WINDOW in  $(wmctrl -l | grep "$ACTUAL_WORKSPACE $(hostname)" | grep -v Emperador | cut -d' ' -f1); do
        wmctrl -v -i -r $TASKBAR_WINDOW -b remove,skip_taskbar
      done;      
      while read TASKBAR_WINDOW;  do
        wmctrl -v -i -r $TASKBAR_WINDOW -b add,skip_taskbar
      done < <(grep ^$ACTUAL_WORKSPACE $FICHERO | cut -d' ' -f2)
    fi;  
    if [ "$1" == "cerrar" ] # Si queremos resetear todo
    then 
     for TASKBAR_WINDOW in  $(wmctrl -l | grep "$ACTUAL_WORKSPACE $(hostname)" | grep -v Emperador | cut -d' ' -f1)
     do
       wmctrl -v -i -r $TASKBAR_WINDOW -b remove,skip_taskbar
       wmctrl -v -i -r $TASKBAR_WINDOW -b remove,below,above
     done 
    fi;
  return 0
}

[ ! -e $FICHERO ] && touch $FICHERO

if [ "$1" == "primer_plano" ]
then
  wmctrl -v -i -r $ACTUAL_WINDOW -b toggle,above
  if ( ! grep $ACTUAL_WINDOW $FICHERO )  then
    echo $ACTUAL_WORKSPACE $ACTUAL_WINDOW arriba  \($ACTUAL_TITULO\) >> $FICHERO
  else 
   sed -i "/$ACTUAL_WINDOW/d" $FICHERO
  fi;
  exit 0
fi;

# Si le pasamos el cerrar que quite el bloqueo
if [[ "$1" == "cerrar"  &&  ! $(grep -q  ^$ACTUAL_WORKSPACE $FICHERO) ]]
then
  sed -i "/^$ACTUAL_WORKSPACE/d" $FICHERO
  taskbar $1
  echo Salimos
  exit 0
fi;


# Sino existe la configuracion para ese workspace la creamos y establecemos
if ( ! grep ^$ACTUAL_WORKSPACE $FICHERO )  then
 echo $ACTUAL_WORKSPACE $ACTUAL_WINDOW primero  \($ACTUAL_TITULO\) >> $FICHERO
 echo Nos aseguramos
 wmctrl -v -i -r $ACTUAL_WINDOW  -b remove,above
 wmctrl -v -i -r $ACTUAL_WINDOW  -b add,below
fi;

while read LINEA
do
  ACTUAL_WINDOW=$(echo $LINEA | cut -d' ' -f2)
  ACTUAL_ESTADO=$(echo $LINEA | cut -d' ' -f3)
  if [ "$ACTUAL_ESTADO" == "arriba" ]; then
    
    wmctrl -v -i -r $ACTUAL_WINDOW  -b toggle,below,above
   #  Tengo que buscar algu metodo para ponerle el foco a la siguiente ventana que no este en el fichero 
#wmctrl -i -R $ACTUAL_WINDOW # Le ponemos el foco
    sed -i "s/\(^$ACTUAL_WORKSPACE $ACTUAL_WINDOW.*\)arriba/\1abajo/" $FICHERO

  elif [ "$ACTUAL_ESTADO" == "abajo" ]; then
  
     wmctrl -v -i -r $ACTUAL_WINDOW  -b toggle,below,above
     wmctrl -i -R $ACTUAL_WINDOW  # Le ponemos el foco a la ventana
     sed -i "s/\(^$ACTUAL_WORKSPACE $ACTUAL_WINDOW.*\)abajo/\1arriba/" $FICHERO

  else # Se trata de la primera vez 

    [ -z $FOCUS_WINDOW ] || wmctrl -v -i -R $FOCUS_WINDOW
    sed -i "s/\(^$ACTUAL_WORKSPACE $ACTUAL_WINDOW.*\)primero/\1abajo/" $FICHERO

  fi;
done < <(grep ^$ACTUAL_WORKSPACE $FICHERO)
# Feisiiiimo
taskbar $ACTUAL_ESTADO # Establecemos  el taskbar
