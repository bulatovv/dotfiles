#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
notify-send --icon=~/Pictures/icons/eye.png "Прошло 20 минут" "Время сделать перерыв"
