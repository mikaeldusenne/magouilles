#!/bin/sh

set -eu

source ./.env

mkdir -p data/mongo

touch data/mongo/.dbshell
envsubst < mongo/mongo-init.js > config/mongo/mongo-init.js


mkdir -p config/mongo
