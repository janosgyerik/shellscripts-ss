#!/usr/bin/env bash

slugify() {
    echo ${1//[^a-zA-Z0-9]/-}
}

report() {
    echo
    echo Commands executed:
    for cmd in "${executed[@]}"; do
        echo "  $cmd"
    done
    echo
    echo "$@"
    echo
    echo See logs in: $log
    echo
}

run() {
    executed+=("$*")
    if ! "$@"; then
        report "Fatal: command exited with error: $@"
        exit 1
    fi
}

log=/tmp/mvn-$(slugify "$0")

executed=()

set -e
{
    run mvn clean install
    for p in its/plugin its/ruling; do
        test -d $p || continue
        run mvn clean install -f $p
    done

    report "Congrats, all looking good!"
} | tee "$log"
