#!/bin/zsh

set -e

a=(keycloak gitlab jupyterhub jupyterhub/jupyter matrix/matrix matrix/element vue)

SHOULD_COPY="$2"

function run(){
    echo "installing SSL certificates for $1"
    mkdir -p "$1/certificates"
    
    certificate_creator.sh \
        --name "$1" \
        --dest $(realpath "$1/certificates") \
        --p12
    
    CRT_FILE=$(find "$1/certificates" -name '*crt*')
    
    if [ "$SHOULD_COPY" = "1" ]; then
        for ee in $a; do
            if [ "$ee" != "$1" ]; then
                if ! [ -d "$ee" ]; then
                    echo "creating $ee"
                    mkdir -p "$ee"
                fi
                echo "copy $CRT_FILE to $ee"
                cp "$CRT_FILE" "$ee/"
            fi
        done
    fi
}

# for e in $a; do
#     run $e
# done

run "$1"
