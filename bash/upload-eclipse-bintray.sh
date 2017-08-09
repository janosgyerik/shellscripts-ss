#!/bin/sh
#
# SCRIPT: update-eclipse-bintray.sh
# AUTHOR: janos <janos@frostgiant>
# DATE:   2017-08-09
#

set -e

usage() {
    test $# = 0 || echo "$@"
    echo "Usage: $0 [OPTION]... [ARG]..."
    echo
    echo Upload Eclipse artifacts to bintray
    echo
    echo Options:
    echo
    echo "  -h, --help         Print this help"
    echo
    exit 1
}

args=
#flag=off
#param=
while test $# != 0; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
#    -p|--param) shift; param=$1 ;;
#    --) shift; while test $# != 0; do args="$args \"$1\""; shift; done; break ;;
    -|-?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
    esac
    shift
done

eval "set -- $args"  # save arguments in $@. Use "$@" in for loops, not $@ 

test $# -gt 0 || usage

token=

test "$token" || usage

login=janos-ss:$token
version=3.2.1.201708090836
basedir=~/Downloads
artifact=org.sonarlint.eclipse.site
repourl=https://api.bintray.com/content/sonarsource/SonarLint-for-Eclipse
releaseType=snapshots

curl -u$login -T $basedir/$artifact-$version.zip $repourl/$releaseType/$version/$releaseType/$artifact-$version.zip
curl -u$login -T $basedir/$artifact-$version.zip $repourl/$releaseType/$version/$releaseType/$version/$artifact-$version.zip?explode=1
