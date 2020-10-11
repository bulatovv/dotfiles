#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
dunstify --appname="Напоминание" --icon=~/.icons/eye_normal.png "Прошло 20 минут" "Пора оторваться от монитора"
