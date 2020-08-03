#!/bin/sh

[ $(pgrep mpd) ] || mpd & $TERMINAL -e ncmpcpp
