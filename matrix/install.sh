#!/bin/bash

set -e
set -u

echo 'setting up matrix...'

source .env
EDS_CONTAINER_PREFIX=${EDS_CONTAINER_PREFIX:-eds}

mkdir -p ./matrix/matrix/data/
touch ./matrix/matrix/data/homeserver.yaml # to have write rights
touch matrix/matrix/data/$EDS_CONTAINER_PREFIX-matrix.log.config # to have write rights

sudo chown 991:991 ./matrix/matrix/data

envsubst < matrix/matrix/homeserver.yaml > matrix/matrix/data/homeserver.yaml
cp matrix/matrix/matrix.log.config matrix/matrix/data/$EDS_CONTAINER_PREFIX-matrix.log.config 

# sed 's;/homeserver.log;/data/homeserver.log;' matrix/matrix/eds-matrix.log.config && cat matrix/matrix/data/eds-matrix.log.config | grep homeserver.log
envsubst < matrix/element/element-config_template.json > matrix/element/element-config.json

echo 'Done setting up matrix.'
