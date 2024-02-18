#!/bin/bash

set -e
set -u

echo 'setting up nginx...'

SERVER_CERTS="$1"

mkdir -p nginx/certificates

cp -i "$1/privkey.pem" nginx/certificates/privkey.pem
cp -i "$1/fullchain.pem" nginx/certificates/fullchain.pem

sed "s/\$EDS_DOMAIN/${EDS_DOMAIN}/" nginx/nginx_template.conf > nginx/nginx.conf

echo 'Done setting up nginx.'
