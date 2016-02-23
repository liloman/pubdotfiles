#!/bin/bash
#Genera un diagrama del codigo fuente que le pasemos

cflow --cpp --format=posix --omit-arguments --level-indent='0=\t' --level-indent='1=\t' --level-indent=start='\t' $* > /tmp/cflow.tmp
cflow2dot < /tmp/cflow.tmp > /tmp/cflow.dot
dot -Tpng -G"300,900" /tmp/cflow.dot -o /tmp/cflow.png
display /tmp/cflow.png
