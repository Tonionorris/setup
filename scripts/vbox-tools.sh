#!/bin/bash

dist=$(uname -r)
apt-get install dkms build-essential $dist
apt-get install gcc
mount /dev/cdrom /media/cdrom
sudo ./media/cdrom/VBoxLinuxAdditions.run
