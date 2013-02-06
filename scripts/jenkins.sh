#!/bin/bash

jenkins="java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080"

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

echo "# Jenkins
deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get install -y jenkins

# setup apache proxy
a2enmod proxy
a2enmod proxy_http
a2enmod vhost_alias

echo "<VirtualHost *:80>
	ServerAdmin ovh@valain.com
	ServerName jenkins.vaconsulting.lu
	ProxyRequests Off
	<Proxy *>
		Order deny,allow
		Allow from all
	</Proxy>
	ProxyPreserveHost on
	ProxyPass / http://localhost:8080/
</VirtualHost>" > /etc/apache2/sites-available/jenkins

a2ensite jenkins
service apache2 reload

# install required pear packages
pear upgrade PEAR
pear config-set auto_discover 1
pear install pear.phpqatools.org/phpqatools pear.netpirates.net/phpDox-0.4.0

# install jenkins plugins
wget http://localhost:8080/jnlpJars/jenkins-cli.jar && mv jenkins-cli.jar /usr/local/bin/jenkins-cli.jar

grep_output=$(grep -c jenkins /etc/profile)
if [ $grep_output -eq 0 ]; then
	echo 'alias jenkins="$jenkins"' >> /etc/profile
	source /etc/profile
fi

$jenkins install-plugin phing analysis-collector checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit github

$jenkins safe-restart