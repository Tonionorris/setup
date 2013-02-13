#!/bin/bash

mount /dev/cdrom /media/cdrom
tar -xzvf /media/cdrom/VMwareTools-* -C /tmp/
cd /tmp/vmware-tools-distrib/
sudo ./vmware-install.pl -d