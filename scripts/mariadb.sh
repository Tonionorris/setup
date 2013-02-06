#!/bin/bash

sudo apt-get install python-software-properties
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://mariadb.cu.be//repo/10.0/ubuntu precise main'

apt-get update
apt-get install -y mariadb-server mariadb-client