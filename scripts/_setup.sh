#!/bin/bash

PACKAGE="$1"

cd /tmp/setup-sandbox

wget https://raw.github.com/vaconsulting/setup/master/scripts/$PACKAGE.sh
chmod +x $PACKAGE.sh
echo "Start installing $PACKAGE";
sleep 1;
./$PACKAGE.sh