#!/bin/sh

alias getcolor=~/.scripts/colors/get.sh

device=$1
type=$2
line=$(nmcli -t d | grep ^$device)


state=$(echo $line | cut -d: -f3)
last_state=$(cat ~/.cache/network/$1/last_state)
connection=$(echo $line | cut -d: -f4)

msgId="5050"
bgcolor=$(getcolor background)

case $state in
    connected*)
        color=$(getcolor color2)
        [ "$state" = "$last_state" ] || (dunstify "$device" "Подключен к $connection" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/i/${type}_green.png \
                                                  --replace=$msgId \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color \
                                                  --hints=string:bgcolor:$bgcolor
                                         echo $state > ~/.cache/network/$1/last_state)
        ;;
    connecting*)
        color=$(getcolor color3)
        [ "$state" = "$last_state" ] || (dunstify "$device" "Подключаюсь к $connection" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/i/${type}_yellow.png \
                                                  --replace=$msgId \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color \
                                                  --hints=string:bgcolor:$bgcolor
                                         echo $state > ~/.cache/network/$1/last_state)
        ;;
    disconnected*)
        color=$(getcolor color8)
        [ "$last_state" = "connected" ] && (dunstify "$device" "Устройcтво отключено" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/i/${type}_low.png \
                                                  --replace=$msgId \
                                                  --urgency=CRITICAL \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color \
                                                  --hints=string:bgcolor:$bgcolor
                                            echo $state > ~/.cache/network/$1/last_state)
        ;;
    unavailable*)
        color=$(getcolor color1)
        [ "$state" = "$last_state" ] || (dunstify "$device" "Устройство недоступно" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/i/${type}_critical.png \
                                                  --replace=$msgId \
                                                  --urgency=CRITICAL \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color \
                                                  --hints=string:bgcolor:$bgcolor
                                         echo $state > ~/.cache/network/$1/last_state)
esac

echo $connection
echo $connection
echo $color 
