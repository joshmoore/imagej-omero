#!/bin/sh

# Note: script has been extracted from build.sh to simplify local testing

set -e
set -x

export BACKUPURL=${BACKUPURL:-file:///.travis/omero_test_infra_backup.zip}
export INFRABRANCH=${INFRABRANCH:-integration}
export INFRAREPO=${INFRAREPO:-git://github.com/joshmoore/omero-test-infra}
if [ ! -d .omero ];
then
    git clone -b ${INFRABRANCH} ${INFRAREPO} .omero
fi

.omero/download.sh ${BACKUPURL} $PWD/.travis
.omero/persist.sh --restore /tmp

# FIXME: setting DOCKER_ARGS here should work but it's not.
# It fails with:
# [ERROR] Could not create local repository at /home/mvn/.m2/repository -> [Help 1]
# env DOCKER_ARGS="-v $HOME/.m2:/home/mvn/.m2"

export OMERO_SERVER_VERSION=5.3
export OMERO_WEB_VERSION=5.3
export COMPOSE_FILE="docker-compose.yml:volumes.yml"
.omero/docker lib
# Optionally persist for a next run
