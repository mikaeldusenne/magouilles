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


./lib/create_certificates.sh --name keycloak --copy
./lib/create_certificates.sh --name jupyterhub --copy
./lib/create_certificates.sh --name gitlab --copy
./lib/create_certificates.sh --name matrix/matrix --copy


while IFS= read -r secret; do
    lib/create_env "$secret" .env
done <<EOF
KEYCLOAK_USER_PASSWORD
KEYCLOAK_ADMIN_PASSWORD
KEYCLOAK_CLIENT_SECRET
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
bash ./keycloak/install.sh

echo 'done.'
