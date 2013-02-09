#!/bin/bash

ZEND_DEBUGGER_CONF=/usr/local/zend/etc/conf.d/debugger.ini
ZEND_EXT_MANAG_CONF=/usr/local/zend/etc/conf.d/extension_manager.ini
XDEBUG_EXT=zend_extension=/usr/local/zend/lib/php_extensions/xdebug.so

# install xdebug for zend server
pecl install xdebug

# disable zend debugger
DISABLED=$(cat $ZEND_DEBUGGER_CONF | grep -c ';zend_extension_manager\.dir\.debugger')
if [ $DISABLED -eq 0 ] ; then
	sed '2,2s/zend_extension_manager\.dir\.debugger/;zend_extension_manager\.dir\.debugger/' \
	$ZEND_DEBUGGER_CONF > $ZEND_DEBUGGER_CONF.tmp
	rm ZEND_DEBUGGER_CONF
	mv ZEND_DEBUGGER_CONF.tmp ZEND_DEBUGGER_CONF
fi
SETUP=$(cat $ZEND_EXT_MANAG_CONF | grep -c $XDEBUG_EXT)
if [ $SETUP -eq 0 ] ; then
	sed "2i$XDEBUG_EXT"
fi
/usr/local/zend/bin/zendctl.sh restart

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
	ServerName jenkins.vac.lu
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

# open fd
exec 3>&1
 
# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Install" \
	  --separate-output \
	  --backtitle "" \
	  --clear \
	  --title "Jenkins plugins" \
	  --checklist "Choose plugins" \
15 70 0 \
	phing "phing" on \
	analysis-collector "analysis-collector" on \
	checkstyle "checkstyle" on \
	cloverphp "cloverphp" on \
	htmlpublisher "htmlpublisher" on \
	jdepend "jdepend" on \
	plot "plot" on \
	pmd "pmd" on \
	violations "violations" on \
	xunit "xunit" on \
	github "github" on \
2>&1 1>&3)

RESULT=$?

# close fd
exec 3>&-

if [ $RESULT -eq 0 ] ; then

	# Inject the list of available plugin in Jenkins 
	
	# Get the update center ourself
	WGETRESULT=$(wget -nv -S -O default.js http://updates.jenkins-ci.org/update-center.json 2>&1 | grep -c "200 OK")

	if [ $WGETRESULT -eq 1 ] ; then
	  
		# remove first and last line javascript wrapper
		sed '1d;$d' default.js > default.json
		 
		# Now push it to the update URL
		curl -X POST -H "Accept: application/json" -d @default.json http://localhost:8080/updateCenter/byId/default/postBack
		
			
		# Now install the desired plugins
		$JENKINS install-plugin $VALUES
	fi
fi


$JENKINS safe-restart
