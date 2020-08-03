#!/bin/sh

layout=$(xkblayout-state print %s)
[ $layout = ru ] && color=#FF5555 || color=#87D7FF
echo "  $layout  "
echo $layout
echo "#000000"
echo $color
