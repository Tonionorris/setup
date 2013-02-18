#!/bin/bash

mount /dev/cdrom /media/cdrom
clear

while [ ! -f /media/cdrom/VBoxLinuxAdditions.run ]
do
	read -p "Please, insert the Virtual box guest additions disc and press [o]k or [a]bort" response
	if [ $response eq "a" ]
	then
		exit
	fi
	mount /dev/cdrom /media/cdrom
	clear
done

dist=$(uname -r)
apt-get install dkms build-essential $dist
apt-get install gcc
sudo ./media/cdrom/VBoxLinuxAdditions.run
