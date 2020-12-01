#!/bin/sh

color=$(/home/bulatov/.scripts/colors/get.sh color4)
bgcolor=$(/home/bulatov/.scripts/colors/get.sh background)

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
dunstify --appname="Напоминание" \
         --hints=string:frcolor:$color \
         --hints=string:fgcolor:$color \
         --hints=string:bgcolor:$bgcolor "Прошло 20 минут" "Время оторваться от экрана"
