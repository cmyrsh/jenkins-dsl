#!bin/sh



# this scripts builds simple apache httpd image and mounts our html directory

# get directory path
cd ..
html_path=`pwd`

# create container
docker rm -f dsl-apache
docker create --name dsl-apache -v $html_path:/var/www/html:ro -p 18080:80 httpd:alpine
docker run dsl-apache
