#!/bin/bash

clear
mount /dev/cdrom /media/cdrom

while [ ! -f /media/cdrom/VBoxLinuxAdditions.run ]
do
	read response -p "Please, insert the Virtual box guest additions disc and press [o]k or [a]bort"
	if [ $response eq "a" ]
	then
		exit
	fi
	clear
	mount /dev/cdrom /media/cdrom
done

dist=$(uname -r)
apt-get install dkms build-essential $dist
apt-get install gcc
sudo ./media/cdrom/VBoxLinuxAdditions.run
