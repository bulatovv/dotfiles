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

_hello() {
    echo hello world
}


view() {
    case $(file $1) in
        *image\ data*)   setsid -f sxiv $1;;
        *.mp4*)          setsid -f mpv $1;;
        *.pdf*)          setsid -f zathura $1;;
        *.doc*|*.ppt*)   setsid -f libreoffice $1;;
        *ASCII*|*UTF-8*) cat $1;; 
    esac
}

edit() {
    case $(file $1) in
        *image\ data*)   setsid -f gimp $1;;
        *.doc*|*.ppt*)  setsid -f libreoffice $1;;
        *ASCII*|*UTF-8*) vim $1;; 
    esac
}
