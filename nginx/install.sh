#!/bin/bash

set -e
set -u

echo 'setting up nginx...'

source .env

mkdir -p nginx/certificates

if [ -n "$SERVER_CERTS" ]; then
    cp -i "$SERVER_CERTS/privkey.pem" nginx/certificates/privkey.pem
    cp -i "$SERVER_CERTS/fullchain.pem" nginx/certificates/fullchain.pem
else
    ./lib/create_certificates.sh nginx
    cp -i "./nginx/certificates/nginx.key" ./nginx/certificates/privkey.pem
    cp -i "./nginx/certificates/nginx.crt" ./nginx/certificates/fullchain.pem
fi

sed "s/\$EDS_DOMAIN/${EDS_DOMAIN}/" nginx/nginx_template.conf > nginx/nginx.conf

echo 'Done setting up nginx.'
