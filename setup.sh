#!/bin/bash


# update installed
apt-get update
apt-get dist-upgrade -y
apt-get install dialog -y

# open fd
exec 3>&1
 
# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Install" \
	  --separate-output \
	  --backtitle "" \
	  --clear \
	  --title "Setup your server" \
	  --checklist "Choose packages to install" \
15 70 0 \
	mariadb "MariaDB server" off \
	subversion "SVN client" off \
	git "git client" off \
	zend-server "Zend Server" off \
	webmin "Webmin management interface" off \
	composer "Composer" off \
	jenkins "Jenkins continuous integration server" off \
2>&1 1>&3)

RESULT=$?

# close fd
exec 3>&-

if [ $RESULT -neq 0 ] ; then
	exit
fi

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

#Cleaning packages
apt-get autoremove -y
