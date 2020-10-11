#!/bin/sh

device=$1
type=$2
line=$(nmcli -t d | grep ^$device)


state=$(echo $line | cut -d: -f3)
last_state=$(cat ~/.cache/network/$1/last_state)
connection=$(echo $line | cut -d: -f4)

msgId="5050"

case $state in
    connected*)
        color="#50FA7B"
        [ "$state" = "$last_state" ] || (dunstify "$device" "Подключен к $connection" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/${type}_green.png \
                                                  --replace=$msgId \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color
                                         echo $state > ~/.cache/network/$1/last_state)
        ;;
    connecting*)
        color="#F1FA8C"
        [ "$state" = "$last_state" ] || (dunstify "$device" "Подключаюсь к $connection" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/${type}_yellow.png \
                                                  --replace=$msgId \
                                                  --hints=string:frcolor:$color \
                                                  --hints=string:fgcolor:$color
                                         echo $state > ~/.cache/network/$1/last_state)
        ;;
    disconnected*)
        color="#FF5555"
        [ "$last_state" = "connected" ] && (dunstify "$device" "Устройcтво отключено" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/${type}_critical.png \
                                                  --replace=$msgId \
                                                  --urgency=CRITICAL
                                            echo $state > ~/.cache/network/$1/last_state)
        ;;
    unavailable*)
        color="#4D4D4D"
        [ "$state" = "$last_state" ] || (dunstify "$device" "Устройство недоступно" \
                                                  --appname=${type^^} \
                                                  --icon=~/.icons/${type}_critical.png \
                                                  --replace=$msgId \
                                                  --urgency=CRITICAL
                                         echo $state > ~/.cache/network/$1/last_state)
esac

echo $connection
echo $connection
echo $color 
