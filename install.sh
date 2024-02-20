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

./lib/create_certificates.sh --name keycloak --copy
./lib/create_certificates.sh --name jupyterhub --copy
./lib/create_certificates.sh --name gitlab --copy

function create_env(){
    echo "creating secret key for '$1'"
    if ! grep -q "^export $1=" .env; then
        echo "export $1='$(randompass 64 'a-zA-Z0-9_')'" >> .env
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

bash ./jupyterhub/install.sh
bash ./matrix/install.sh
sudo bash ./nginx/install.sh


# set up realm and OIDC clients
docker compose -f compose_keycloak.yml, compose_keycloak_realm_initialize.yml up --build --abort-on-container-exit

echo 'done.'
