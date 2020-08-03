#!/bin/sh

device=$(ls /sys/class/ieee80211/*/device/net)
name=$(nmcli -c no c | grep "$device" | cut -d ' ' -f1)



case $(nmcli g) in
    *disconnected*) status="disconnected" color="#FF5555";;
    *connected*) color=#50FA7B;;
    *connecting*) status="connecting:" color=#50FA7B;;
esac

echo $status $name
echo $status $name 
echo $color
