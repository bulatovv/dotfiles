#!/bin/sh

[ $(pamixer --get-mute) = "true" ] && (echo "🔇" && echo && echo "#FF5555") && exit 

vol=$(pamixer --get-volume)
[ $vol -le 1 ] && echo "🔈$vol%" && exit 0  
[ $vol -le 75 ] && echo "🔉$vol%" || echo "🔊$vol%"
