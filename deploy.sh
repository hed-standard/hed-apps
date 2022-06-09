#!/bin/bash

# deploy.sh - A script used to _build and deploy a docker container for the HEDTools online validator

if [ $# -eq 0 ]; then
  BRANCH="master"
else
  BRANCH="$1"
fi
##### Constants

DEPLOY_DIR=${PWD}
IMAGE_NAME="hed-apps:latest"
CONTAINER_NAME="hed-apps"
GIT_APPS_REPO_URL="https://github.com/hed-standard/hed-apps"
GIT_APPS_REPO_BRANCH=${BRANCH}
SOURCE_DEPLOY_DIR="${DEPLOY_DIR}/hed-apps"


##### Functions

cleanup_directory()
{
echo "Cleaning up directory ${SOURCE_DEPLOY_DIR} ..."
rm -rf "${SOURCE_DEPLOY_DIR}"
}

clone_github_repos(){
echo "Deploy dir: ${DEPLOY_DIR}"
cd ${DEPLOY_DIR}
echo "Cloning repo ${GIT_APPS_REPO_URL}  in ${DEPLOY_DIR} using ${GIT_APPS_REPO_BRANCH} branch"
git clone $GIT_APPS_REPO_URL -b $GIT_APP_REPO_BRANCH
}


build_new_container()
{
cd ${SOURCE_DEPLOY_DIR}
echo "Building new container ${IMAGE_NAME}  in ${SOURCE_DEPLOY_DIR}"
docker build -t $IMAGE_NAME .
}

delete_old_container()
{
echo "Deleting old container ${CONTAINER_NAME} ..."
docker rm -f $CONTAINER_NAME
}

run_new_container()
{
echo "Running new container $CONTAINER_NAME ..."
docker run --restart=always --name $CONTAINER_NAME -d -p 127.0.0.1:$HOST_PORT:$CONTAINER_PORT $IMAGE_NAME
}


error_exit()
{
	echo "$1" 1>&2
	exit 1
}

output_paths()
{
echo "The relevant deployment information is:"
echo "Deploy directory: ${DEPLOY_DIR}"
echo "Source deploy directory": ${SOURCE_DEPLOY_DIR}
}

##### Main
echo "Starting...."
output_paths
echo "....."
# echo "Cleaning up directories before deploying..."
cleanup_directory
clone_github_repos || error_exit "Cannot clone repo ${GIT_APPS_REPO_URL}"
build_new_container
delete_old_container
run_new_container

