#!/bin/sh

if [ $# -ne 2 ]
  then
    echo "This script expects 2 arguments 'apache_port html_path'"
    echo "apache_port: port on which apache listens\n html_path: path where application files are kept"
    exit 1

fi

# this scripts builds simple apache httpd image and mounts our html directory
apache_port=$1
# get directory path
curr_dir=`pwd`
home_dir=`dirname $curr_dir`
html_path=$2

# create container
docker rm -f dsl-apache
docker create --name dsl-apache -v $html_path:/var/www/html:ro -p $apache_port:80 httpd:alpine
docker start dsl-apache
