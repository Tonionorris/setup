#!/bin/bash

wget -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add -

echo "# Webmin
deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list

apt-get update
apt-get install -y webmin