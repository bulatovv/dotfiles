#!/bin/sh

[ -d ~/.cache/sxivweb ] || mkdir -p ~/.cache/sxivweb

name=$(date +%s)

curl -s "$1" > ~/.cache/sxivweb/$name
sxiv ~/.cache/sxivweb/$name
rm -rf ~/.cache/sxivweb/$name
