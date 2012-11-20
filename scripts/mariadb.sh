#!/bin/bash

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1BB943DB

echo "# MariaDB 5.5 repository list - created 2012-11-20 22:31 UTC
# http://downloads.mariadb.org/mariadb/repositories/
deb http://ftp.igh.cnrs.fr/pub/mariadb//repo/5.5/ubuntu precise main
deb-src http://ftp.igh.cnrs.fr/pub/mariadb//repo/5.5/ubuntu precise main" > /etc/apt/sources.list.d/MariaDB.list

apt-get update
apt-get install -y mariadb-server mariadb-client