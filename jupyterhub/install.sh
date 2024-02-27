#!/bin/sh

set -eu

echo 'setting up jupyterhub...'
source ./.env

# prepare jupyterhub docker spawning instances
(cd jupyterhub/jupyter && docker build . -t "${EDS_IMAGE_PREFIX:-eds}-jupyter")

#########################
## Config
#########################

mkdir -p ./config/jupyterhub/
envsubst < jupyterhub/jupyterhub_config.py > ./config/jupyterhub/jupyterhub_config.py

#########################
## Data
#########################

mkdir -p ./data/jupyterhub/data


echo 'Done setting up jupyterhub.'
