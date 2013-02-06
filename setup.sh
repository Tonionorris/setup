#!/bin/bash

apt-get install dialog -y

mariadb=""
zend-server=""
subversion=""
git=""
jenkins=""
webmin=""

# open fd
exec 3>&1
 
# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Install" \
	  --separate-output \
	  --backtitle "" \
	  --title "Setup your server" \
	  --checklist "Choose packages to install" \
15 70 0 \
	mariadb "MariaDB server" off \
	subversion "SVN client" off \
	git "git client" off \
	zend-server "Zend Server" off \
	webmin "Webmin management interface" off \
	jenkins "Jenkins continuous integration server" off \
2>&1 1>&3)
 
# close fd
exec 3>&-
clear

# update installed
apt-get update
apt-get dist-upgrade -y

# prepare temp folder
mkdir -p /tmp/setup
cd /tmp/setup
rm -Rf *

# get proxy setup file
wget https://raw.github.com/vaconsulting/setup/master/scripts/_setup.sh
chmod +x _setup.sh
# display values just entered
for PACKAGE in $VALUES
do
	./_setup.sh $PACKAGE
done