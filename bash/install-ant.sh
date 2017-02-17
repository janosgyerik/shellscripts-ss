#!/usr/bin/env bash

if type ant &>/dev/null; then
    echo Ant is already installed. Exit.
    exit 1
fi

set -ex

baseurl=http://mirror.switch.ch/mirror/apache/dist/ant/binaries
filename=apache-ant-1.10.1-bin.tar.gz
url=$baseurl/$filename
basename=${filename%-bin.tar.gz}
target_install=/usr/share
target_bin=/usr/bin

tmpdir=$(mktemp -d)
(
cd $tmpdir
curl -sSO $baseurl/$filename
tar zxf $filename

sudo cp -r $basename $target_install/
sudo update-alternatives --install $target_bin/ant ant $target_install/$basename/bin/ant 200
sudo update-alternatives --set ant $target_install/$basename/bin/ant
)
