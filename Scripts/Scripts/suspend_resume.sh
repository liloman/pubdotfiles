#!/usr/bin/env bash

#Executed before/after sleep.target
echo "hola $@ $(date)" >> /tmp/hola.txt
