#!/bin/sh

# handle inputs. 2 inputs, port and publishport

if [ $# -ne 4 ]
  then
    echo "This script expects 4 arguments 'jenkins_image_name container_name port publishport'"
    echo "jenkins_image_name: name of jenkins image\ncontainer_name: name of container\nport: port on which jenkins will run, \npublishport: port on which jenkins will listen to slaves"
    exit 1

fi

# set ports
jenkins_image=$1
container_name=$2
port=$3
publish_port=$4

curr_dir=`pwd`
home_dir=`dirname $curr_dir`

# make persitance dirs
jenkins_data=$home_dir/jenkins_data/$container_name

if [ -d "$jenkins_data" ]; then
  # Clean
  rm -vrf $jenkins_data
fi

mkdir -p $jenkins_data

# build jenkins
docker rm -f $container_name
#cd docker && docker create --restart=unless-stopped --name jenkins-primary -p $port:8080 -p $publish_port:50000 -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -v $jenkins_data:/var/jenkins_home --prefix=/jenkins jenkins:alpine
cd docker && docker create --restart=unless-stopped --name $container_name -p $port:8080 -p $publish_port:50000 -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -v $jenkins_data:/var/jenkins_home --env JENKINS_OPTS="--prefix=/jenkins -Djenkins.install.runSetupWizard=false" --env JAVA_OPTS="-Dinstall.dir=$jenkins_data" $jenkins_image

