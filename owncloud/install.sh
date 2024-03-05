#!/bin/bash

set -eux

source .env

echo 'checking if oidc package is extracted...'
if [ ! -e ./config/owncloud/apps/openidconnect ]; then
    mkdir -p ./config/owncloud/apps
    tar xzvf ./owncloud/openidconnect-2.2.0.tar.gz -C ./config/owncloud/apps/
fi

if cat config/owncloud/config.php | grep -q -i 'installed.*false'; then
    echo 'creating ./config/owncloud/config.php...'
    envsubst "$(sed -n '3,$p' ./owncloud/config_template.php)" < ./owncloud/config_template.php > ./config/owncloud/config.php
    
    echo 'starting docker...'
    docker-compose -f compose_network.yml -f compose_owncloud.yml up -d
    docker-compose -f compose_network.yml -f compose_owncloud.yml logs -f > docker_logs.txt &
    tail -f docker_logs.txt &
    
    echo 'sleeping 20 seconds...'
    sleep 60
    
    echo 'enabling oidc owncloud app'
    docker exec --user www-data eds-owncloud occ app:enable openidconnect

    echo 'shutting down...'
    docker-compose -f compose_network.yml -f compose_owncloud.yml down
fi

# echo 'installing OnlyOffice collaborative tool...'
# if [ ! -e docker-onlyoffice-owncloud ]; then
#     echo 'cloning repo...'
#     (
#         git clone --recursive https://github.com/ONLYOFFICE/docker-onlyoffice-owncloud && \
#         cd docker-onlyoffice-owncloud && \
#         git submodule update --init --remote --recursive
#     )
# fi


echo 'done.'
