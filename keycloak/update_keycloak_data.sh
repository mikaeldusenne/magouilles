#!/bin/bash

set -eu

source .env

# This should be ran on a running environment

# # optional build command
# docker build -t "${EDS_IMAGE_PREFIX:-eds}-keycloak-python" ./docker-python


# docker compose -f compose_network.yml -f compose_keycloak_realm_initialize.yml up --build --abort-on-container-exit

docker run \
  --rm \
  --name "${EDS_CONTAINER_PREFIX:-eds}-keycloak-python-update" \
  -e KEYCLOAK_ADMIN_PASSWORD \
  -e KEYCLOAK_ADMIN \
  -e KEYCLOAK_GITLAB_SECRET \
  -e KEYCLOAK_JUPYTER_SECRET \
  -e KEYCLOAK_MATRIX_SECRET \
  -e EDS_DOMAIN \
  -e EDS_CONTAINER_PREFIX \
  -v $(pwd)/keycloak/realm_setup.py:/app/realm_setup.py \
  -v $(pwd)/keycloak/python_setup_data/:/app/data/ \
  --network="${EDS_CONTAINER_PREFIX:-eds}-network" \
  --entrypoint python \
  "${EDS_IMAGE_PREFIX:-eds}-keycloak-python" \
  ./realm_setup.py

