#!/bin/bash

VERSION="5.4"
wget http://repos.zend.com/zend.key -O- |apt-key add -

echo "# Zend Server
deb http://repos.zend.com/zend-server/deb server non-free
deb http://repos.zend.com/zend-server/preview-php5.4/deb server non-free" > /etc/apt/sources.list.d/zend-server.list

apt-get update
apt-get install -y zend-server-php-$VERSION php-$VERSION-extra-extensions-zend-server

grep_output=$(grep -c "\/usr\/local\/zend\/lib" /etc/profile)

if [ $grep_output -eq 0 ]; then
	echo "PATH=\$PATH:/usr/local/zend/bin
LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/zend/lib" >> /etc/profile
	source /etc/profile
fi

/usr/local/zend/bin/pear update-channels
/usr/local/zend/bin/pear channel-discover pear.phpunit.de
/usr/local/zend/bin/pear channel-discover pear.symfony.com
/usr/local/zend/bin/pear channel-discover pear.phing.info
/usr/local/zend/bin/pear channel-discover pear.pdepend.org
/usr/local/zend/bin/pear channel-discover pear.phpmd.org
/usr/local/zend/bin/pear channel-discover pear.phpdoc.org
/usr/local/zend/bin/pear upgrade-all
/usr/local/zend/bin/pear install --alldeps phpunit/PHPUnit
/usr/local/zend/bin/pear install phing/phing
updatedb
source /etc/profile