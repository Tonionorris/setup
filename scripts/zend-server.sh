#!/bin/bash

PEAR=/usr/local/zend/bin/pear
PECL=/usr/local/zend/bin/pecl

VERSION="5.4"
wget http://repos.zend.com/zend.key -O- |apt-key add -

echo "# Zend Server
deb http://repos.zend.com/zend-server/6.0/deb_ssl1.0 server non-free" > /etc/apt/sources.list.d/zend-server.list

apt-get update
apt-get install -y zend-server-php-$VERSION build-essential automake

grep_output=$(grep -c "\/usr\/local\/zend\/lib" /etc/profile)

if [ $grep_output -eq 0 ]; then
	echo "PATH=\$PATH:/usr/local/zend/bin
LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/zend/lib" >> /etc/profile
	source /etc/profile
fi

$PECL install xdebug
xdebug_enabled=$(grep -c "xdebug" /usr/local/zend/etc/php.ini)

if [ $xdebug_enabled -eq 0 ]; then
    echo "\
zend_extension=\"/usr/local/zend/lib/php_extensions/xdebug.so\"" >> /usr/local/zend/etc/php.ini
fi

$PEAR update-channels
$PEAR channel-discover pear.phpunit.de
$PEAR channel-discover pear.symfony.com
$PEAR channel-discover pear.phing.info
$PEAR channel-discover pear.pdepend.org
$PEAR channel-discover pear.phpmd.org
$PEAR channel-discover pear.phpdoc.org
$PEAR upgrade-all
$PEAR install --alldeps phpunit/PHPUnit
$PEAR install --alldeps phpunit/DbUnit
$PEAR install phing/phing
updatedb
/usr/local/zend/bin/zendctl.sh restart
source /etc/profile
ln -s /usr/local/zend/bin/php /usr/bin/php