#!/bin/zsh

set -e
set -u

COPY_DEST=(keycloak gitlab jupyterhub jupyterhub/jupyter matrix/matrix matrix/element vue)

function error(){
	echo "$1" >&2
	exit 1
}

while [[ $# > 0 ]];do
	case "$1" in
        --name) NAME=$2; shift ;;
        --copy) SHOULD_COPY=1 ;;
        *) error "unsupported argument: $1";;
	esac
	shift
done


function run(){
    echo "installing SSL certificates for $1"
    mkdir -p "$1/certificates"
    
    certificate_creator.sh \
        --name "$1" \
        --dest $(realpath "$1/certificates") \
        --p12
    
    CRT_FILE=$(find "$1/certificates" -name '*crt*')
    
    if [ -n "$SHOULD_COPY" ]; then
        for ee in $COPY_DEST; do
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

run "$NAME"
