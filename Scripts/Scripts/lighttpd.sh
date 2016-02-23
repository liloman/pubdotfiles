#!/usr/bin/env bash

hash lighttpd 2>/dev/null || { echo "Please install lighttpd first" ; exit; }

dir="${1:-$PWD}"
dir="$(realpath -P $dir)"
config=/tmp/lighttpd.conf 
port=8080

echo -n "
server.document-root = \"$dir\"
server.port          = $port
#server.dir-listing = "enable"
" > $config

killall -q lighttpd 
lighttpd -f "$config" && echo "Running on http://localhost:$port for $dir"
