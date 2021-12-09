xwallpaper --zoom ~/.config/wallpaper &
dunst &
picom -b &
xrdb .Xresources
setxkbmap -layout us,ru -option grp:alt_shift_toggle
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
exec i3
