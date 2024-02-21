#!/bin/zsh

set -e
set -u

COPY_DEST=(keycloak gitlab jupyterhub jupyterhub/jupyter matrix/matrix matrix/element vue)

function error(){
	echo "$1" >&2
	exit 1
}

SHOULD_COPY="0"
SAN=""

while [[ $# > 0 ]];do
	case "$1" in
        --name) NAME=$2; shift ;;
        --san) SAN=$2; shift ;;
        --copy) SHOULD_COPY=1 ;;
        *) error "unsupported argument: $1";;
	esac
	shift
done


function run(){
    echo "installing SSL certificates for $1"
    mkdir -p "$1/certificates"
    
    ./lib/certificate_creator.sh \
        --name "$1" \
        --san "$SAN" \
        --dest $(realpath "$1/certificates") \
        --p12
    
    CRT_FILE=$(find "$1/certificates" -name '*crt*')
    
    if [ "$SHOULD_COPY" = "1" ]; then
        for ee in $COPY_DEST; do
            mkdir -p "$ee/trusted-certs/"
            if [ "$ee" != "$1" ]; then
                if ! [ -d "$ee" ]; then
                    echo "creating $ee"
                    mkdir -p "$ee"
                fi
                echo "copy $CRT_FILE to $ee"
                cp "$CRT_FILE" "$ee/trusted-certs/"
            fi
        done
    fi
}

# for e in $a; do
#     run $e
# done

run "$NAME"
