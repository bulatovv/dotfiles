#!/bin/sh

echo $(~/.scripts/colors/get.sh $1)$(~/.scripts/colors/get.sh $2) | python -c 'print("#"+hex(sum([int(x,16) for x in input()[1:].split("#")])//2)[2:].upper())'
