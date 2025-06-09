#!/bin/bash
SPATH=~/.scripts/themeswitch

theme=$(cat $SPATH/current)
echo $theme
#cat $SPATH/themes.json | jq -cr .themes.$theme.icon
[ $BLOCK_BUTTON == 1 ] && $SPATH/switch.sh


