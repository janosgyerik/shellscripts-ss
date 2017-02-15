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

extra_test_projects=()

found_its_subs=no
test -d its/plugin && { extra_test_projects+=(its/plugin); found_its_subs=yes; }
test -d its/ruling && { extra_test_projects+=(its/ruling); found_its_subs=yes; }
test -d its && test $found_its_subs = no && extra_test_projects+=(its)

found_it_subs=no
test -d it/plugin && { extra_test_projects+=(it/plugin); found_it_subs=yes; }
test -d it/ruling && { extra_test_projects+=(it/ruling); found_it_subs=yes; }
test -d it && test $found_it_subs = no && extra_test_projects+=(it)

set -e
{
    run mvn clean install
    for p in "${extra_test_projects[@]}"; do
        run mvn clean install -f $p
    done

    report "Congrats, all looking good!"
} | tee "$log"
