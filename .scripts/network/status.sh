#!/bin/sh

device=$1
line=$(nmcli -t d | grep ^$device)


state=$(echo $line | cut -d: -f3)
connection=$(echo $line | cut -d: -f4)
#[ $connection ] || connection='--'

case $state in
    connected*)
        color="#50FA7B"
        ;;
    connecting*)
        color="#F1FA8C"
        ;;
    disconnected*)
        color="#FF5555"
        ;;
    unavailable*)
        color="#4D4D4D"
esac

echo $connection
echo $connection
echo $color 
