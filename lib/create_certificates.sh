#!/bin/zsh

set -e

a=(keycloak gitlab jupyterhub jupyterhub/jupyter matrix/matrix vue)

function run(){
    echo "installing SSL certificates for $1"
    mkdir -p "$1/certificates"
    
    # TMPDIR=$(mktemp -d -t certificate_creator_XXXX)

    certificate_creator.sh \
        --name "$1" \
        --dest $(realpath "$1/certificates") \
        --p12
        # $([ "$1" = "keycloak" ] && printf -- "-p12" || echo '')
    
    CRT_FILE=$(find "$1/certificates" -name '*crt*')
    
    for ee in $a; do
        if [ "$ee" != "$1" ]; then
            if ! [ -d "$ee" ]; then
                echo "creating $ee"
                mkdir -p "$ee"
            fi
            echo "copy $CRT_FILE to $ee"
            cp "$CRT_FILE" "$ee/"
            # cp -i $(find "$1/certificates" -name '*crt*') "$ee/"
            # find "$1/certificates" -name '*crt*' -exec cp -i {} "$ee/" \;
        fi
    done
    
}

# for e in $a; do
#     run $e
# done

run "$1"
