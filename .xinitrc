xwallpaper --zoom ~/.config/wallpaper &
dunst &
picom -b &
xsettingsd &
xrdb .Xresources
setxkbmap -layout us,ru -option grp:alt_shift_toggle
exec i3
