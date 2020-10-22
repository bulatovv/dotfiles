
#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
dunstify --appname="Напоминание" --icon=~/.icons/sitting_normal.png "Прошел час" "Время оторваться от стула"
