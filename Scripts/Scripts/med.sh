#!/usr/bin/env bash

. ~/Scripts/libnotify

repeat() {
    local -i i=0
    notify_dark "$1" " ..."
    for(( i = 0; i <= $2; i++ )) { 
        echo -ne "$1 $i   \r"
        sleep 1
    }
    echo "$1"
}

prana () {
    repeat "1->Aspira " 8
    repeat "2->Aguanta " 8
    repeat "3->Exhala " 8
    repeat "4->Aguanta " 8
}

wim () {
    local -i i=0
    repeat "1->Tummo! " 120
    notify_dark "Exhalaaaaaaaa" " ..."
    read -p "2->Exhalo y comienzo a esperar!" pause
    start=$SECONDS
    for(( i = 0; i < 300; i++ )) { echo -ne "$i\r"; read -p "Duracion: " -N 1 -t 1 end; [[ $end ]] && i=3000; }
    echo "Duracion $((SECONDS - start))."
    echo "3->Inhala y aguanta"
    sleep 18
    notify_dark "4->Exhala y preparate para la siguiente iteracion" "..."
    sleep 20
}

#Check it out!
[[ $1 ]] || { echo "$0 (prana|wim)"; exit 1; }

# https://www.youtube.com/watch?v=LPuCXc5MSgY
if [[ $1 == prana ]]; then
    for (( i = 1; i <= 7; i++ )); do
        echo "Iteraccion $i    "
        echo "=============="
        prana 
    done
elif [[ $1 == wim ]]; then #wim hoff
    for (( i = 1; i <= 4; i++ )); do
        echo "Iteraccion $i    "
        echo "=============="
        wim 
    done
fi

notify_dark "Doneee $1" " Well done!"
