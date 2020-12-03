#!/bin/sh

screenshots_path=~/Pictures/screenshots
name=$(date +%s).png
case $1 in
    --select)
        maim -s $screenshots_path/$name
        ;;
    --full)
        maim $screenshots_path/$name
esac
(cat $screenshots_path/$name | xclip -selection clipboard -t image/png -i) &

color=$(~/.scripts/colors/get.sh color4)
bgcolor=$(~/.scripts/colors/get.sh background)

dunstify --appname="Снимок экрана" "Сохранен в ~/Pictures/screenshots" \
          --icon=~/.icons/i/screenshot_normal.png \
          --hints=string:frcolor:$color \
          --hints=string:fgcolor:$color \
          --hints=string:bgcolor:$bgcolor
