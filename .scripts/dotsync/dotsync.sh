#!/bin/sh

FROM=~
DEST=~/.cache/dotfiles

confirm () {
    read -r -p "start syncing? [y/N] " response
    case "$response" in
    [yY][eE][sS]|[yY]) 
        echo yes
        ;;
    *)
        echo no
        ;;
    esac
}

clear () {
    for file in $DEST/.*; do
        [ $(echo $file | grep ".git\|README.md") ] || rm -rf $file 2>/dev/null
    done
}

copy () {
    cat ~/.scripts/dotsync/tosync | while read -r line ; do
        mkdir -p $(dirname $line | sed s!$FROM!$DEST!g)
        cp -r $line $(echo $line | sed s!$FROM!$DEST!g)
    done
}

push () {
    git -C $DEST status -s
    git -C $DEST add -A
    git -C $DEST commit -m "$1"
    git -C $DEST push -u origin master
}

main () {
    if [ $(confirm) = yes ]; then
        echo -e "\033[31mSomething went wrong\033[0m" > /tmp/dotsync.log
        clear 2>>/tmp/dotsync.log &&
        copy 2>>/tmp/dotsync.log  && 
        push "$1" 2>>/tmp/dotsync.log  || cat /tmp/dotsync.log
    else
        echo -e "\033[31mAborted\033[0m"
    fi
}

main "$1"
