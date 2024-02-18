#!/bin/zsh

set -e
set -u

source .env

(cd docker-openssl && docker build . -t docker-openssl)

LIB_PATH=$(pwd)/lib
if ! grep -q "$LIB_PATH" $PATH; then
    echo "adding $LIB_PATH to PATH."
    export PATH="$PATH:$LIB_PATH"
fi

echo 'setting up...'

EDS_NETWORK=${EDS_NETWORK:-eds_network}
docker network create $EDS_NETWORK || echo "network $EDS_NETWORK already exists."

./lib/create_certificates.sh keycloak
./lib/create_certificates.sh jupyterhub
./lib/create_certificates.sh gitlab

function create_env(){
    echo "creating secret key for '$1'"
    if ! grep -q "^export $1=" .env; then
        echo "\nexport $1='$(randompass 64 'a-zA-Z0-9_')'" >> .env
    else
        echo "$1 already exists."
    fi
}

while IFS= read -r secret; do
    create_env "$secret"
done <<EOF
KEYCLOAK_USER_PASSWORD
KEYCLOAK_ADMIN_PASSWORD
KEYCLOAK_GITLAB_SECRET
KEYCLOAK_JUPYTER_SECRET
KEYCLOAK_POSTGRES_PASSWORD
KEYCLOAK_MATRIX_SECRET
MATRIX_POSTGRES_PASSWORD
MATRIX_MACAROON_SECRET_KEY
MATRIX_FORM_SECRET
MATRIX_REGISTRATION_SHARED_SECRET
EOF

echo 'done.'
