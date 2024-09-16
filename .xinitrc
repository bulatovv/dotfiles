xwallpaper --zoom ~/.config/wallpaper &
dunst &
picom -b &
xrdb .Xresources
setxkbmap -layout us,ru -option grp:alt_shift_toggle
exec i3
xrandr --output --primary eDP --right-of HDMI-A-0 &
blueman-applet &
