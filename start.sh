#!/bin/bash

docker compose \
       -f compose_network.yml \
       -f compose_nginx.yml \
       -f compose_keycloak.yml \
       -f compose_jupyter.yml \
       -f compose_matrix.yml \
       -f compose_gitlab.yml \
       up --abort-on-container-exit --build

if [ "$1" = "1" ]; then
    sudo ./lib/set_hosts
fi
