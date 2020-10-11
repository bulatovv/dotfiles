#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
notify-send --icon=~/.icons/eye_normal.png "Прошло 20 минут" "Пора сделать перерыв"
