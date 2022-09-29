#!/usr/bin/env bash

alias getcolor=~/.scripts/colors/get.sh

change() {
	brightnessctl s $1 > /dev/null 2>&1
}

msgID="1010"

case $1 in
    up)
        change +5%
        ;;
    down)
        change 5%-
        ;;
esac

dunstify \
    "Текущий уровень: $(brightnessctl -m | cut -d ',' -f 4)" \
    --appname="Яркость" \
    --replace=$msgID \
    --urgency=LOW \
    --icon=~/.icons/i/brightness_low.png
    
