#!/bin/bash

# install xdebug for zend server
pecl install xdebug

JENKINS="java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080"

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

# Grab the jenkins CLI
wget http://localhost:8080/jnlpJars/jenkins-cli.jar && mv jenkins-cli.jar /usr/local/bin/jenkins-cli.jar

grep_output=$(grep -c jenkins /etc/profile)
if [ $grep_output -eq 0 ]; then
	echo "alias jenkins=\"$JENKINS\"" >> /etc/profile
	source /etc/profile
fi
 
# Inject the list of available plugin in Jenkins 

# Get the update center ourself
wget -O default.js http://updates.jenkins-ci.org/update-center.json
 
# remove first and last line javascript wrapper
sed '1d;$d' default.js > default.json
 
# Now push it to the update URL
curl -X POST -H "Accept: application/json" -d @default.json http://localhost:8080/updateCenter/byId/default/postBack --verbose

# Now install the desired plugins
$JENKINS install-plugin phing analysis-collector checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit github

$JENKINS safe-restart
