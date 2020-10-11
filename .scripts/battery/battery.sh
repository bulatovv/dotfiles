#!/bin/dash


perc=$(cat /sys/class/power_supply/BAT1/capacity)
state=$(cat /sys/class/power_supply/BAT1/status)

[ $state = "Charging" ] && icon="⚡" 

echo $icon$perc%
echo $icon$perc%

[ $perc -le 10 ] && [ $state = "Discharging" ] && state="Critical"


msgID="7070"
[ $state = $(cat ~/.cache/battery/last_state) ] || (
    case $state in
        Full)
            dunstify "Полный заряд" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --hints=string:frcolor:#50fa7b \
                      --hints=string:fgcolor:#50fa7b \
                      --icon=~/.icons/battery_green.png
            ;;
        Charging)
            dunstify "Питание подключено" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --hints=string:frcolor:#50fa7b \
                      --hints=string:fgcolor:#50fa7b \
                      --icon=~/.icons/battery_green.png
            ;;
        Discharging)
            dunstify "Питание отключено" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --urgency=LOW \
                      --icon=~/.icons/battery_low.png
            ;;
        Critical)
            dunstify "Заряд на исходе" \
                      --appname="Батарея" \
                      --replace=$msgID \
                      --urgency=CRITICAL \
                      --icon=~/.icons/battery_critical.png
    esac
    echo $state > ~/.cache/battery/last_state
)
[ -z $icon ] && (
    [ $perc -le 10 ] && echo "#FF5555" && exit 0
    [ $perc -le 21 ] && echo "#F8A871" && exit 0
    [ $perc -le 31 ] && echo "#F5D17F" && exit 0
    [ $perc -le 51 ] && echo "#F1FA8C"
) || echo "#50FA7B"
