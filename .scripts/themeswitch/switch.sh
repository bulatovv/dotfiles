#!/bin/bash
SPATH=~/.scripts/themeswitch
CPATH=~/.cache/themeswitch

panic() {
    [ "$1" ] && echo -ne "\033[3;31m$1: \033[0m" >&2
    echo -e "\033[0;31m$2\033[0m" >&2
    exit
}

set_gtk_theme() {
    if [ -d "/usr/share/themes/$1" ] || [ -d "~/.themes/$1" ]; then
        echo "Net/ThemeName \"$1\"" > ~/.xsettingsd
        timeout 0.5s xsettingsd > /dev/null &>2
    else
        panic ${FUNCNAME[0]} "Cannot load gtk-theme $1 from /usr/share/themes or ~/.themes."
    fi
}

set_wallpaper() {
    if [ -f ~/.config/$1 ]; then
        xwallpaper --zoom ~/.config/$1
        ln -f ~/.config/$1 ~/.config/wallpaper
    else
        panic ${FUNCNAME[0]} "Cannot setup wallpaper ~/.config/$1. No such file"
    fi

}

set_xresources() {
    if [ -f "$HOME/$1"  ]; then
        xrdb "$HOME/$1"
        ln -f "$HOME/$1" "$HOME/.Xresources"
    else
        panic ${FUNCNAME[0]} "Cannot load $1 from $HOME"
    fi
}

set_nvim_theme() {
    ln -f ~/.config/nvim/$1.vim ~/.config/nvim/theme.vim
    for server in $(nvr --serverlist); do 
        nvr --servername $server --remote-send "<Esc>:color $1<Return><C-l>" & 
    done
}

set_alacritty_theme() {
    if [ -f ~/.config/alacritty/$1 ]; then
        ln -f ~/.config/alacritty/$1 ~/.config/alacritty/alacritty.yml
    else
        panic ${FUNCNAME[0]} "~/.config/alacritty/$1 - no such file"
    fi
}

set_dunst_icons() {
    if [ -d ~/.icons/$1 ]; then
        ln -sfn ~/.icons/$1 ~/.icons/i
    else
        panic ${FUNCNAME[0]} "~/.icons/$1 - no such directory"
    fi
}

switch_to() {
    echo "$1" > $CPATH/current
    theme=$(cat $SPATH/themes.json | jq -c .themes.$1)
    if [ "$1" ] && [ "$theme" != null ]; then
        set_wallpaper $(cat $SPATH/themes.json | jq -cr .themes.$1.wallpaper) &
        set_alacritty_theme $(cat $SPATH/themes.json | jq -cr .themes.$1.alacritty) &
        set_gtk_theme $(cat $SPATH/themes.json | jq -cr .themes.$1.gtk) &
        set_dunst_icons $(cat $SPATH/themes.json | jq -cr .themes.$1.dunst_icons) &
        set_nvim_theme $(cat $SPATH/themes.json | jq -cr .themes.$1.nvim) &
        set_xresources $(cat $SPATH/themes.json | jq -cr .themes.$1.Xresources)
        cat $SPATH/themes.json | jq -cr .on_switch[] | while read -r cmd; do
            $cmd
        done
    else
        panic "$1" "No such theme in themes.json"
    fi
}

get_next() { # TODO
    current="start"
    for next in $(cat $SPATH/themes.json | jq -cr .order[]); do
        if [ $current == $(cat $CPATH/current) ]; then
            echo $next
            break
        fi
        current=$next
    done
    [ $current == $next ] && echo $(cat $SPATH/themes.json | jq -cr '.order[0]')
}


case $1 in
    --to)
        switch_to $2
        ;;
    *)
        switch_to $(get_next)
        ;;
esac
