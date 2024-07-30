#!/bin/zsh

set -eu

source .env

(
    git clone https://github.com/mikaeldusenne/jitsi-keycloak-adapter.git && \
        cd jitsi-keycloak-adapter && \
        git checkout origin/authenticate-from-private-network
)

# (
#     git clone git@github.com:mikaeldusenne/jitsi-keycloak-adapter.git && \
#         cd jitsi-keycloak-adapter && \
#         git checkout origin/authenticate-from-private-network
# )

# cd jitsi

# if ! [ -e "jitsi-meet-cfg" ]; then
    
# wget $(curl -s https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep 'zip' | cut -d\" -f4)
# unzip $(ls -tr | tail -n1)
# mv -i $(find . -maxdepth 1 -type d  -name '*jitsi-docker-jitsi-meet*') jitsi-docker

# cd jitsi-docker
mkdir -p ./config/jitsi/
JITSI_ENV_PATH=./config/jitsi/.env

cp -i ./jitsi/.env.template "${JITSI_ENV_PATH}.tmp"

while IFS= read -r secret; do
    ./lib/create_env "$secret" "${JITSI_ENV_PATH}.tmp"
done <<EOF
JWT_APP_SECRET
JICOFO_AUTH_PASSWORD
JVB_AUTH_PASSWORD
JIGASI_XMPP_PASSWORD
JIBRI_RECORDER_PASSWORD
JIBRI_XMPP_PASSWORD
EOF

envsubst < "${JITSI_ENV_PATH}.tmp" > "${JITSI_ENV_PATH}"
rm "${JITSI_ENV_PATH}.tmp"
# cp ./.env.tmp ./.env
# cp ../docker-compose.yml ./

# ./gen-passwords.sh

# mkdir -p ./jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}



# envsubst < jitsi/.env.template > jitsi/jitsi-docker/.env

# # delete previous
# sed -i '/#### Jisty/,/#### END_Jitsy/d' .env

# # append new
# echo '#### Jisty' >> .env
# envsubst < jitsi/jitsi-docker/.env >> .env
# echo '#### END_Jitsy' >> .env


# # web/config.js
# config.prejoinConfig = {enabled: false, hideDisplayName: true};
# config.disableDeepLinking=true
