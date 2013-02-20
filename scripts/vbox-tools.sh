#!/bin/bash

mount /dev/cdrom /media/cdrom


while [ ! -f /media/cdrom/VBoxLinuxAdditions.run ]
do
	clear
	read -p "Please, insert the Virtual box guest additions disc and press 'enter' or [a]bort ?" response
	if [ "$response" = "a" ]
	then
		exit
	fi
	mount /dev/cdrom /media/cdrom
done

dist=$(uname -r)
apt-get -y install dkms build-essential $dist
apt-get -y install gcc
/media/cdrom/VBoxLinuxAdditions.run
