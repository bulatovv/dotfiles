#!/usr/bin/env bash

FROM=~
DEST=~/.cache/dotfiles

confirm () {
    read -r -p "$1 [y/N] " response
    case "$response" in
    [yY][eE][sS]|[yY]) 
        echo 1
        ;;
    esac
}

clean () {
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
    git -C $DEST commit -m "$1"
    git -C $DEST push -u origin master
}


read -r -d '' USAGE << EOF
Usage:
    --copy
        Copy all files from tosync-list to local git repo
    --status
        Check git status on local repo
    --include
        Add files to local repo index
    --exclude
        Remove files from local repo index
    --push "comment"
        Push changes to remote repo
    --full "comment"
        Copy all files from tosync-list and push them to remote repo
EOF


echo -e "\033[31mSomething went wrong\033[0m" > /tmp/dotsync.log
case $1 in
    *copy)
        clean 2>>/tmp/dotsync.log &&
        copy 2>>/tmp/dotsync.log  || cat /tmp/dotsync.log
        ;;
    *status)
        git -C $DEST status -s
        ;;
    *include)
        shift
        git -C $DEST add $@
        ;;
    *exclude)
        shift
        git -C $DEST restore --staged $@
        ;;
    *push)
        push "$2" 2>>/tmp/dotsync.log  || cat /tmp/dotsync.log
        ;;
    *full)
        git -C $DEST status -s
        if [ $(confirm "Start full syncing?") ]; then
            clean 2>>/tmp/dotsync.log &&
            copy 2>>/tmp/dotsync.log  && 
            git -C $DEST add -A &&
            push "$2" 2>>/tmp/dotsync.log  || cat /tmp/dotsync.log
        else
            echo -e "\033[31mAborted\033[0m"
        fi
        ;;
    *|help)
        echo "$USAGE"
        ;;
esac
