#!/bin/sh

set -eu

source ./.env

mkdir -p data/mongo

touch data/mongo/.dbshell



mkdir -p config/mongo

envsubst < mongo/mongo-init.js > config/mongo/mongo-init.js
