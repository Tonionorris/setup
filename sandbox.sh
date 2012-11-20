#!/bin/bash

apt-get update
apt-get dist-upgrade -y

mkdir -p /tmp/setup-sandbox
cd /tmp/setup-sandbox
rm -Rf *
wget https://raw.github.com/fdewinne/setup/master/scripts/mariadb.sh
chmod +x mariadb.sh
./mariadb.sh