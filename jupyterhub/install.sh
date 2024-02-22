#!/bin/sh

set -e
set -u

echo 'setting up jupyterhub...'
source ./.env

# prepare jupyterhub docker spawning instances
(cd jupyterhub/jupyter && docker build . -t "${EDS_IMAGE_PREFIX:-eds}-jupyter")

mkdir -p jupyterhub/data
# cp jupyterhub/jupyterhub_config.py jupyterhub/data
envsubst < jupyterhub/jupyterhub_config.py > jupyterhub/data/jupyterhub_config.py

echo 'Done setting up jupyterhub.'
