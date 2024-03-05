#!/bin/zsh

set -e
set -u

source .env

(cd docker-openssl && docker build . -t docker-openssl)

echo 'setting up...'


./lib/create_certificates.sh --name keycloak --copy
./lib/create_certificates.sh --name jupyterhub --copy
./lib/create_certificates.sh --name gitlab --copy
./lib/create_certificates.sh --name matrix/matrix --copy
# ./lib/create_certificates.sh --name owncloud --copy


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
MONGO_INITDB_ROOT_PASSWORD
MONGO_INITDB_USER_PASSWORD
OWNCLOUD_ADMIN_PASSWORD
OWNCLOUD_ADMIN_PASSWORD
OWNCLOUD_DB_ROOT_PASSWORD
OWNCLOUD_DB_USER_PASSWORD
OWNCLOUD_SECRET
OWNCLOUD_SALT
EOF

bash ./jupyterhub/install.sh
bash ./matrix/install.sh
sudo bash ./nginx/install.sh
bash ./keycloak/install.sh
bash ./website/frontend/install.sh
bash ./jitsi/install.sh
bash ./mongo/install.sh
bash ./owncloud/install.sh

echo 'done.'
