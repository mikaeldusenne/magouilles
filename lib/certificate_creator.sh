#!/bin/zsh

set -e
set -u

# openssl x509 -in keycloak.crt.pem -text -noout
function error(){
	echo "$1" >&2
	exit 1
}

function validate(){
    if [[ -n "$2" && $2 != "--"* ]]; then
        echo "$2"
    else
        echo "validation failed for argument to $1 : <<$2>>" >&2
        exit 1
    fi
}

P12=""

while [[ $# > 0 ]];do
	case "$1" in
        --common-name) COMMON_NAME=$(validate "$1" "$2"); shift ;;
        --dest) DEST=$(validate "$1" "$2") ;;
        --name) NAME=$(validate "$1" "$2"); shift ;;
        --p12) P12=1 ;;
        --*) error "unsupported argument: $1";;
	esac
	shift
done

DEST=${DEST:-"./"}
COMMON_NAME=${COMMON_NAME:-"eds-$NAME"}

[ -z "$COMMON_NAME" ] && error 'must specify a CommonName'
[ -z "$NAME" ] && error 'must specify a name'

echo "creating a certificate for $NAME (CN=$COMMON_NAME) to $DEST..."

function run_openssl(){
    docker run \
           -u $(id -u ${USER}):$(id -g ${USER}) \
           -v $DEST:/openssl-certs docker-openssl \
           $@
}

run_openssl req -x509 -newkey rsa:2048 -nodes -keyout $NAME.key -out $NAME.crt -days 365 -subj "/CN=$COMMON_NAME" -addext "subjectAltName = DNS:$COMMON_NAME, DNS:localhost, IP:127.0.0.1" -sha256


if [ "$P12" = "1" ]; then
	run_openssl pkcs12 -export -in $NAME.crt -inkey $NAME.key -out $NAME.p12 -name server -password pass:changeit
fi


# openssl x509 -in $DEST/$NAME.crt -text -noout
