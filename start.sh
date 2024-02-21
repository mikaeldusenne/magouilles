#!/bin/bash


# if [ -z "$1" ]; then
#     args='up --abort-on-container-exit --build'
# else
#     args=$@
# fi

yamls=''
action='up --abort-on-container-exit --build'

while [[ $# > 0 ]];do
	case "$1" in
        --action)
            
            action=$2;
            shift ;;
        *) yamls="$yamls -f compose_${1}.yml" ;;
	esac
	shift
done

if [ -z "$yamls" ]; then
    yamls="-f compose_network.yml -f compose_nginx.yml -f compose_keycloak.yml -f compose_jupyter.yml -f compose_matrix.yml -f compose_gitlab.yml"
fi


echo $action | grep -q "\bup\b" && ./lib/eds_recreate_network
echo $action | grep -q "\bup\b" && (sleep 10 && sudo ./lib/set_hosts) &

echo "docker compose $yamls $action"
docker compose $yamls $action

echo $action | grep -q "\bup\b" && docker compose $yamls down

