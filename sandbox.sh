#!/bin/bash

apt-get update
apt-get dist-upgrade -y

mkdir -p /tmp/setup-sandbox
cd /tmp/setup-sandbox
rm -Rf *

wget https://raw.github.com/fdewinne/setup/master/scripts/_setup.sh
chmod +x _setup.sh
./_setup.sh mariadb
./_setup.sh subversion
./_setup.sh git