#!/bin/sh

set -e
set -u

echo 'setting up jupyterhub...'

# prepare jupyterhub docker spawning instances
cd jupyterhub/jupyter && docker build . -t $JUPYTERHUB_JUPYTER_IMAGE_NAME

echo 'Done setting up jupyterhub.'
