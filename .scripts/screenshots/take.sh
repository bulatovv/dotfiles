#!/bin/sh

source ~/.scripts/colors/get.sh

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


dunstify --appname="Снимок экрана" "Сохранен в ~/Pictures/screenshots" \
          --icon=~/.icons/i/screenshot_normal.png \
          --urgency=NORMAL
