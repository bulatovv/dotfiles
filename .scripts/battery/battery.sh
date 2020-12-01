#!/bin/dash
alias getcolor=~/.scripts/colors/get.sh
alias mixcolor=~/.scripts/colors/mix.sh


perc=$(cat /sys/class/power_supply/BAT1/capacity)
state=$(cat /sys/class/power_supply/BAT1/status)

[ $state = "Charging" ] && icon="⚡" 

echo $icon$perc%
echo $icon$perc%

[ $perc -le 10 ] && [ $state = "Discharging" ] && state="Critical"


msgID="7070"
bgcolor=$(getcolor background)

[ $state = $(cat ~/.cache/battery/last_state) ] || (
    case $state in
        Full)
            color=$(getcolor color2)
            dunstify "Полный заряд" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --hints=string:frcolor:$color \
                      --hints=string:fgcolor:$color \
                      --hints=string:bgcolor:$bgcolor \
                      --icon=~/.icons/i/battery_green.png
            ;;
        Charging)
            color=$(getcolor color2)
            dunstify "Питание подключено" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --hints=string:frcolor:$color \
                      --hints=string:fgcolor:$color \
                      --hints=string:bgcolor:$bgcolor \
                      --icon=~/.icons/i/battery_green.png
            ;;
        Discharging)
            color=$(getcolor color8)
            dunstify "Питание отключено" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --urgency=LOW \
                      --hints=string:frcolor:$color \
                      --hints=string:fgcolor:$color \
                      --hints=string:bgcolor:$bgcolor \
                      --icon=~/.icons/i/battery_low.png
            ;;
        Critical)
            color=$(getcolor color1)
            dunstify "Заряд на исходе" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --urgency=CRITICAL \
                      --hints=string:frcolor:$color \
                      --hints=string:fgcolor:$color \
                      --hints=string:bgcolor:$bgcolor \
                      --icon=~/.icons/i/battery_critical.png
    esac
    echo $state > ~/.cache/battery/last_state
)
[ -z $icon ] && (
    [ $perc -le 10 ] && echo $(getcolor color1) && exit 0
    [ $perc -le 21 ] && echo $(mixcolor color1 color3) && exit 0
    [ $perc -le 31 ] && echo $(getcolor color3) && exit 0
    [ $perc -le 51 ] && echo $(getcolor color3)
) || echo $(getcolor color2)
