#!/bin/bash

wget http://repos.zend.com/zend.key -O- |apt-key add -

echo "# Zend Server
deb http://repos.zend.com/zend-server/6.0/beta/deb server non-free" > /etc/apt/sources.list.d/zend-server.list

apt-get update
apt-get install -y zend-server-php-5.4

grep_output="$(grep \"\/usr\/local\/zend\/lib\" /etc/profile)"

if [ -z "$grep_output" ]; then
	echo "PATH=$PATH:/usr/local/zend/bin
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/zend/lib" >> /etc/profile
	source /etc/profile
fi
