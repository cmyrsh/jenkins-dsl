#!/bin/sh

if [ $# -ne 6 ]
  then
    echo "This script expects 6 arguments 'user group uid gid dockergroupid image_name'"
    echo "user: sytem user which can sudo, \ngroup: group of the system user, \nuid and gid are corresponding ids"
    exit 1

fi

_user=$1
_grp=$2
_uid=$3
_gid=$4
_did=$5
_image_name=$6

# remove existing installation

rm -vrf docker

#clone jenkins repo -- alpine branch
#git clone -b alpine https://github.com/jenkinsci/docker.git


#clone jenkins repo -- alpine branch
git clone  https://github.com/jenkinsci/docker.git

# copy basic securns printity file from current dir to cloned jenkins
cp basic-security.groovy docker/


# extend docker file
# this is done to create and use docker group

echo >> docker/Dockerfile
echo "# Adding given user to docker group" >> docker/Dockerfile
echo "USER root" >> docker/Dockerfile
#echo "RUN addgroup -g $_did docker && usermod -a -G docker $_user" >> docker/Dockerfile
echo "RUN id" >> docker/Dockerfile
echo "RUN groupadd -g $_did docker && usermod -a -G docker $_user" >> docker/Dockerfile
echo "USER $_user" >> docker/Dockerfile
#echo "RUN echo 2.0 > \$JENKINS_HOME/jenkins.install.UpgradeWizard.state" >> docker/Dockerfile
echo "COPY basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy" >> docker/Dockerfile
# install plugins
echo "RUN /usr/local/bin/install-plugins.sh ace-editor ant antisamy-markup-formatter bouncycastle-api branch-api build-timeout cloudbees-folder credentials credentials-binding display-url-api durable-task email-ext external-monitor-job git git-client git-server github github-api github-branch-source github-organization-folder gradle handlebars icon-shim job-dsl jquery-detached junit ldap mailer mapdb-api matrix-auth matrix-project momentjs pam-auth pipeline-build-step pipeline-graph-analysis pipeline-input-step pipeline-milestone-step pipeline-rest-api pipeline-stage-step pipeline-stage-view plain-credentials resource-disposer scm-api script-security ssh-credentials ssh-slaves structs subversion timestamper token-macro windows-slaves workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup groovy" >> docker/Dockerfile

# build jenkins
cd docker && docker build --build-arg user=$_user --build-arg group=$_grp --build-arg uid=$_uid --build-arg gid=$_gid -t $_image_name .



