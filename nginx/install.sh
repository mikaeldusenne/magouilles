#!/bin/bash

set -e

echo 'setting up nginx...'

source .env

mkdir -p nginx/certificates

if [ -n "$SERVER_CERTS" ]; then
    cp -i "$SERVER_CERTS/privkey.pem" nginx/certificates/privkey.pem
    cp -i "$SERVER_CERTS/fullchain.pem" nginx/certificates/fullchain.pem
else
    # ./lib/create_certificates.sh --name nginx
    ./lib/create_certificates.sh --name nginx --san "DNS:keycloak.$EDS_DOMAIN, DNS:gitlab.$EDS_DOMAIN, DNS:matrix.$EDS_DOMAIN, DNS:jupyter.$EDS_DOMAIN, DNS:$EDS_DOMAIN"
    cp -i "./nginx/certificates/nginx.key" ./nginx/certificates/privkey.pem
    cp -i "./nginx/certificates/nginx.crt" ./nginx/certificates/fullchain.pem
fi

EDS_CONTAINER_PREFIX=${EDS_CONTAINER_PREFIX:-eds}
envsubst '$EDS_CONTAINER_PREFIX,$EDS_DOMAIN' < nginx/nginx_template.conf > nginx/nginx.conf

echo 'Done setting up nginx.'
