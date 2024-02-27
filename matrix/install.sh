#!/bin/bash

set -eu

echo 'setting up matrix...'

source .env

EDS_CONTAINER_PREFIX=${EDS_CONTAINER_PREFIX:-eds} # for sudo

########################################################
# Matrix
########################################################

#########################
## Config
#########################

mkdir -p ./config/matrix/matrix/

envsubst < ./matrix/matrix/homeserver.yaml > ./config/matrix/matrix/homeserver.yaml
sudo chown 991:991 ./config/matrix/matrix/homeserver.yaml

cp matrix/matrix/matrix.log.config ./config/matrix/matrix/$EDS_CONTAINER_PREFIX-matrix.log.config
sudo chown 991:991 ./config/matrix/matrix/$EDS_CONTAINER_PREFIX-matrix.log.config

#########################
## Data
#########################

mkdir -p ./data/matrix/matrix/data/
sudo chown 991:991 ./data/matrix/matrix/data/

########################################################
# Element
########################################################


#########################
## Config
#########################

mkdir -p ./config/matrix/element/

envsubst < matrix/element/element-config_template.json > ./config/matrix/element/element-config.json

#########################
## Data
#########################


########################################################
echo 'Done setting up matrix.'
