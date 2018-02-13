#!/bin/sh

# Note: script has been extracted from build.sh to simplify local testing

set -e
set -x

export BACKUPDIR=${BACKUPDIR:-/tmp}
export BACKUPSRC=${BACKUPSRC:-/tmp/backup.zip}
export BACKUPURL=${BACKUPURL:-file:///tmp/fakeurl.zip} # TODO: move to remote resource

export INFRABRANCH=${INFRABRANCH:-master}
export INFRAREPO=${INFRAREPO:-git://github.com/openmicroscopy/omero-test-infra}

# If not present, try to download
if [ ! -f $BACKUPDIR/imagejomero_dbdata.tar ];
then
    curl $BACKUPURL > $BACKUPSRC
    unzip -d $BACKUPDIR $BACKUPSRC
fi

if [ ! -d .omero ];
then
    git clone -b ${INFRABRANCH} ${INFRAREPO} .omero
fi

# FIXME: setting DOCKER_ARGS here should work but it's not.
# It fails with:
# [ERROR] Could not create local repository at /home/mvn/.m2/repository -> [Help 1]
# env DOCKER_ARGS="-v $HOME/.m2:/home/mvn/.m2"

export OMERO_SERVER_VERSION=5.3
export OMERO_WEB_VERSION=5.3
export COMPOSE_FILE="docker-compose.yml:volumes.yml"
.omero/docker lib
# Optionally persist for a next run
