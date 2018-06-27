#!/usr/bin/env bash
set -e

which docker
if [ $? -ne 0 ]
then
    echo "Please install docker."
    exit 1
fi

DIR="`pwd`"
MMS_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
BUILDSPEC="ci/buildspec_pr.yml"

if [[ "$1" == "nightly" ]]; then
	BUILDSPEC="ci/buildspec_nightly.yml"
fi

docker pull amazon/aws-codebuild-local:latest --disable-content-trust=false
docker pull awsdeeplearningteam/mms-build:python2.7 --disable-content-trust=false
docker pull awsdeeplearningteam/mms-build:python3.6 --disable-content-trust=false

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -e "IMAGE_NAME=awsdeeplearningteam/mms-build:python2.7" -e "ARTIFACTS=${MMS_HOME}/build/artifacts2.7" -e "SOURCE=${MMS_HOME}" -e "BUILDSPEC=${BUILDSPEC}" amazon/aws-codebuild-local

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -e "IMAGE_NAME=awsdeeplearningteam/mms-build:python3.6" -e "ARTIFACTS=${MMS_HOME}/build/artifacts3.6" -e "SOURCE=${MMS_HOME}" -e "BUILDSPEC=${BUILDSPEC}" amazon/aws-codebuild-local
