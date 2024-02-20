#!/bin/sh

set -e
set -u

echo 'setting up jupyterhub...'

# prepare jupyterhub docker spawning instances
(cd jupyterhub/jupyter && docker build . -t "${EDS_IMAGE_PREFIX:-eds}-jupyter")

mkdir -p jupyterhub/data
cp -i jupyterhub/jupyterhub_config.py jupyterhub/data

echo 'Done setting up jupyterhub.'
