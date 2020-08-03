#!bin/sh

ex() {
    case $1 in
        *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $1;;
        *.tar.gz|*.tgz) tar xzvf $1;;
        *.tar.xz|*.txz) tar xJvf $1;;
        *.zip) unzip $1;;
        *.rar) unrar x $1;;
        *.7z) 7z x $1;;
    esac
}

_hello () {
    echo hello world
}
