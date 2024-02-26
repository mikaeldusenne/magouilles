#!/bin/bash

set -eu

source .env

args=$@
CMD=""
ARGS=""
IS_CMD='0'

if [ "$@" == "install" ]; then
    CMD='npm install'
elif [ "$@" == "dev" ]; then
    CMD='npm run dev -- --host'
    ARGS='-it -p 8877:5173'
elif [ "$@" == "build" ]; then
    CMD="npm run build"
fi

if [ -z "$CMD" ]; then
    while [[ $# > 0 ]];do
        if [ "$1" = '8' ]; then
            IS_CMD=1
        else
	        case "$IS_CMD" in
                0) ARGS="$ARGS $1";;
                1) CMD="$CMD $1";;
	        esac
        fi
	    shift
    done
fi

echo "ARGS : $ARGS"
echo "CMD  : $CMD"

(
    cd website/frontend/app/ && \
        docker run \
               --name "${EDS_CONTAINER_PREFIX:-eds}-website-vue" \
               --rm \
               -v ${PWD}:/app \
               -w /app \
               -e VITE_EDS_DOMAIN="$EDS_DOMAIN" \
               $ARGS node:20 \
               $CMD
)

