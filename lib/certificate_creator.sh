#!/bin/zsh

set -e
set -u

# openssl x509 -in keycloak.crt.pem -text -noout
function error(){
	echo "$1" >&2
	exit 1
}

function validate(){
    if [[ $2 != "--"* ]]; then
        echo "$2"
    else
        echo "validation failed for argument to $1 : <<$2>>" >&2
        exit 1
    fi
}

P12=""
SAN=""

# --common-name) COMMON_NAME=$(validate "$1" "$2"); shift ;;
while [[ $# > 0 ]];do
	case "$1" in
        --dest) DEST=$(validate "$1" "$2"); shift ;;
        --name) NAME=$(validate "$1" "$2"); shift ;;
        --san) SAN=$(validate "$1" "$2"); shift ;;
        --p12) P12=1 ;;
        *) error "[certificate_creator] unsupported argument: $1";;
	esac
	shift
done

DEST=${DEST:-"./"}

# [ -z "$COMMON_NAME" ] && error 'must specify a CommonName'
[ -z "$NAME" ] && error 'must specify a name'


function run_openssl(){
    docker run \
           -u $(id -u ${USER}):$(id -g ${USER}) \
           -v $DEST:/openssl-certs docker-openssl \
           $@
}

COMMON_NAME_INTERNAL="${EDS_CONTAINER_PREFIX}-${NAME}" # internal docker network name https://eds-name
COMMON_NAME_EXTERNAL="${NAME}.${EDS_DOMAIN}" # external public facing name https://name.eds-domain.com

echo "creating a certificate for $NAME (CN=$COMMON_NAME_INTERNAL, $COMMON_NAME_EXTERNAL) to $DEST..."

SUBJECT_ALT_NAMES="DNS:$COMMON_NAME_EXTERNAL, DNS:$COMMON_NAME_INTERNAL, DNS:localhost, IP:127.0.0.1"

if [ -n "$SAN" ]; then
    SUBJECT_ALT_NAMES="$SUBJECT_ALT_NAMES, $SAN"
fi

echo "SANs: $SUBJECT_ALT_NAMES"

run_openssl req -x509 -newkey rsa:2048 -nodes -keyout $NAME.key -out $NAME.crt -days 365 -subj "/CN=$COMMON_NAME_EXTERNAL" -addext "subjectAltName = $SUBJECT_ALT_NAMES" -sha256


if [ "$P12" = "1" ]; then
	run_openssl pkcs12 -export -in $NAME.crt -inkey $NAME.key -out $NAME.p12 -name server -password pass:changeit
fi


