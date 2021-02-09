#!/usr/bin/env bash

SCRIPT=$(realpath -s $0)
SCRIPTPATH=$(dirname $SCRIPT)
LOGS="${SCRIPTPATH}/logs"

[ -e "${SCRIPTPATH}/list" ] || exit
[ -d "${SCRIPTPATH}/plug" ] || mkdir "${SCRIPTPATH}/plug"
[ -d "$LOGS" ] || mkdir "$LOGS"

__plug_install() {
    cat "${SCRIPTPATH}/list" | while read -r line; do
        echo -e "\033[0;32mInstalling ${line}\033[0m"
        git -C "${SCRIPTPATH}/plug" clone "${line}" > /dev/null 2>>"${LOGS}/${repo}"
    done
}

plug_install() {
    declare -A downloads
    echo -e "\033[0;32mInstalling plugins...\033[0m"
    while read -r line; do
        repo="${line##*/}"
        [ -d "${SCRIPTPATH}/plug/${repo}" ] && continue
        ( git -C "${SCRIPTPATH}/plug" clone "$line" > /dev/null 2>>"${LOGS}/${repo}" ) &
        downloads[$!]="$repo"   
    done < "${SCRIPTPATH}/list"
    
    for d in "${!downloads[@]}"; do
        code=0
        wait "$d" || code=$?
        if [ "$code" != "0" ]; then
            echo -e "\033[0;31mError[$code] occurred when cloned ${downloads[$d]}\033[0m"
        else
            echo -e "\033[0;32m${downloads[$d]} installed!\033[0m"
        fi
    done
}

plug_update() { 
    declare -A fetched
    declare -A merged
    echo -e "\033[0;32mUpdating plugins...\033[0m"
    while read -r line; do
        repo="${line##*/}"
        ( git -C "${SCRIPTPATH}/plug/${repo}" fetch > /dev/null 2>>"${LOGS}/${repo}") &
        fetched[$!]="$repo"   
    done < "${SCRIPTPATH}/list"
    
    for r in "${!fetched[@]}"; do
        wait "$r"
        if [ $(git -C "${SCRIPTPATH}/plug/${fetched[$r]}" rev-parse HEAD) != \
             $(git -C "${SCRIPTPATH}/plug/${fetched[$r]}" rev-parse @{u})    \
        ]; then
            (git -C "${SCRIPTPATH}/plug/${fetched[$r]}" merge origin/master > /dev/null 2>>"${LOGS}/${repo}" ) &
            merged[$!]="${fetched[$r]}"
        else
            echo -e "\033[0;33m${fetched[$r]} is already up to date!\033[0m"
        fi
    done

    for r in "${!merged[@]}"; do
        wait "$r"
        echo -e "\033[0;32m${merged[$r]} updated!\033[0m"
    done

}

plug_clean() {
    for plug in "${SCRIPTPATH}/plug/"*; do
        repo="${plug##*/}"
        if [ ! $(grep $repo "${SCRIPTPATH}/list")  ]; then
            rm -rf $plug
            echo -e "\033[0;31m${repo} was deleted\033[0m"
        fi
    done
}

case $1 in 
    install)
        plug_install
        ;;
    update)
        plug_update
        ;;
    clean)
        plug_clean
esac
