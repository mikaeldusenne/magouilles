#!/bin/bash

echo 'setting up matrix...'

source .env

mkdir -p ./matrix/matrix/data/
chown 991:991 matrix/matrix/data

envsubst < matrix/matrix/homeserver.yaml > matrix/matrix/data/homeserver.yaml

# sed -i 's;/homeserver.log;/data/homeserver.log;' matrix/matrix/data/eds-matrix.log.config && cat matrix/matrix/data/eds-matrix.log.config | grep homeserver.log

envsubst < matrix/element/element-config_template.json > matrix/element/element-config.json

echo 'Done setting up matrix.'
