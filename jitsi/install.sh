#!/bin/zsh

set -eux

source .env

cd jitsi

if ! [ -e "jitsi-meet-cfg" ]; then
    
    wget $(curl -s https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep 'zip' | cut -d\" -f4)

    unzip $(ls -tr | tail -n1)

    mv -i $(find . -maxdepth 1 -type d  -name '*jitsi-docker-jitsi-meet*') jitsi-docker
    
    cd jitsi-docker
    
    # cp -i env.example .env
    cp ../.env.template ./.env
    cp ../docker-compose.yml ./
    
    ./gen-passwords.sh
    
    mkdir -p ./jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

    cd ../
fi

cd ../

# envsubst < jitsi/.env.template > jitsi/jitsi-docker/.env

# delete previous
sed -i '/#### Jisty/,/#### END_Jitsy/d' .env

# append new
echo '#### Jisty' >> .env
envsubst < jitsi/jitsy-docker/.env >> .env
echo '#### END_Jitsy' >> .env



