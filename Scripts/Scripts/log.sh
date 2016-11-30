#!/usr/bin/env bash
RTLOG=/tmp/.output_logs.txt
CALLER=${BASH_SOURCE[1]}
#Log everything to $RTLOG
exec > >(tee -ai $RTLOG ) 2>&1
echo -n  "[logging-> "
[[ -n $CALLER ]] && echo -n "$CALLER $@" || echo -n "$@"
echo "]"
#if not included in a script execute the parameters
[[ -z $CALLER ]] && "$@"
