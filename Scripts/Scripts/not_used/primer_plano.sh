#!/bin/bash
# Activa/Desactiva el primer plano en la ventana activa

ACTUAL_WINDOW=$(wmctrl -a :ACTIVE: -v 2>&1 | grep window | cut -d' ' -f3)
wmctrl -v -i -r $ACTUAL_WINDOW -b toggle,above
