#!/usr/bin/env bash

if test ! -f pom.xml -o ! -d its/plugin -o ! -d its/ruling; then
    cat << EOF
fatal: this script assumes the following files and directories to exist:

    pom.xml
    its/plugin
    its/ruling

EOF
    exit 1
fi

slugify() {
    echo ${1//[^a-zA-Z0-9]/-}
}

log=/tmp/mvn-$(slugify "$0")

{
mvn clean install \
    && mvn clean install -f its/plugin \
    && mvn clean install -f its/ruling \
    && { echo; echo "Congrats, all looking good!"; echo; }
echo The output is saved in: $log
} | tee "$log"
