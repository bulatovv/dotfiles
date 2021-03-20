#!/usr/bin/env bash

SCRIPT=$(realpath -s $0)
SCRIPTPATH=$(dirname $SCRIPT)
LOGS="${SCRIPTPATH}/logs"

[ -e "${SCRIPTPATH}/list" ] || exit
[ -d "${SCRIPTPATH}/plug" ] || mkdir "${SCRIPTPATH}/plug"
[ -d "$LOGS" ] || mkdir "$LOGS"


plug_update() { 
    declare -A downloads
    declare -A fetched
    declare -A merged
    
    echo -e "\033[0;32mUpdating plugins...\033[0m"
    
    while read -r line; do # install plugins
        repo="${line##*/}"
        [ -d "${SCRIPTPATH}/plug/${repo}" ] && continue
        ( git -C "${SCRIPTPATH}/plug" clone "$line" > /dev/null 2>>"${LOGS}/${repo}" ) &
        downloads[$!]="$repo"   
    done < "${SCRIPTPATH}/list"
    
    for d in "${!downloads[@]}"; do
        code=0
        wait "$d" || code=$?
        if [ "$code" != "0" ]; then
            echo -e "${downloads[$d]}: \033[0;31mError[$code] occurred when cloned\033[0m"
        else
            echo -e "\033[0;32m${downloads[$d]}: installed!\033[0m"
        fi
    done
    

    while read -r line; do # update plugins
        repo="${line##*/}"
        case "${downloads[@]}" in
            *$repo*) continue;;
        esac
        ( git -C "${SCRIPTPATH}/plug/${repo}" fetch > /dev/null 2>>"${LOGS}/${repo}") &
        fetched[$!]="$repo"   
    done < "${SCRIPTPATH}/list"
    
    for r in "${!fetched[@]}"; do
        
        code=0
        wait "$r" || code=$?
        if [ "$code" != "0" ]; then
            echo -e "\033[0;31mError[$code] occurred when fetched ${fetched[$r]}\033[0m"
            continue
        fi

        if [ $(git -C "${SCRIPTPATH}/plug/${fetched[$r]}" rev-parse HEAD) != \
             $(git -C "${SCRIPTPATH}/plug/${fetched[$r]}" rev-parse @{u})    \
        ]; then
            (git -C "${SCRIPTPATH}/plug/${fetched[$r]}" merge origin/master > /dev/null 2>>"${LOGS}/${repo}" ) &
            merged[$!]="${fetched[$r]}"
        else
            echo -e "\033[0;33m${fetched[$r]}: already up to date!\033[0m"
        fi
    done

    for r in "${!merged[@]}"; do
        code=0
        wait "$r" || code=$?
        if [ "$code" != "0" ]; then
            echo -e "\033[0;31mError[$code] occurred when merged ${merged[$r]}\033[0m"
        else
            echo -e "\033[0;32m${merged[$r]}: updated!\033[0m"
        fi
    done

    plug_clean

}

plug_clean() {
    for plug in "${SCRIPTPATH}/plug/"*; do
        repo="${plug##*/}"
        if [ ! $(grep $repo "${SCRIPTPATH}/list")  ]; then
            rm -rf $plug
            echo -e "\033[0;31m${repo}: deleted\033[0m"
        fi
    done
}

plug_update
