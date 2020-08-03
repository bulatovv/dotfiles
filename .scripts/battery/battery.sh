#!/bin/dash


perc=$(cat /sys/class/power_supply/BAT1/capacity)

[ $(cat /sys/class/power_supply/BAT1/status) = "Charging" ] && stat="⚡" 

echo $stat$perc%
echo $stat$perc%

[ $perc -le 15 ] && $stat && exit 33
[ $perc -le 21 ] && echo "#F8A871" && exit 0
[ $perc -le 31 ] && echo "#F5D17F" && exit 0
[ $perc -le 51 ] && echo "#F1FA8C" || echo "#50FA7B"
