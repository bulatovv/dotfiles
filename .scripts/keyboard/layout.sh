#!/bin/sh
alias getcolor=~/.scripts/colors/get.sh

layout=$(xkblayout-state print %s)
[ $layout = ru ] && color=$(getcolor color1) || color=$(getcolor color2)
echo "  $layout  "
echo $layout
echo "#000000"
echo $color
