#!/bin/sh

if [ $# -ne 1 ]
  then
    echo "This script expects 1 argument 'apache_port'"
    echo "apache_port: port on which apache listens"
    exit 1

fi

# this scripts builds simple apache httpd image and mounts our html directory
apache_port=$1
# get directory path
cd ..
html_path=`pwd`/html

# create container
docker rm -f dsl-apache
docker create --name dsl-apache -v $html_path:/var/www/html:ro -p $apache_port:80 httpd:alpine
docker start dsl-apache
