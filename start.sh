#!/bin/bash


# if [ -z "$1" ]; then
#     args='up --abort-on-container-exit --build'
# else
#     args=$@
# fi

yamls=''
action='up --abort-on-container-exit --build'

addyaml(){
    [ -f "compose_${1}.yml" ] && echo " -f compose_${1}.yml" || echo " -f $1.yml"
}

while [[ $# > 0 ]];do
	case "$1" in
        --action)
            action=$2;
            shift ;;
        *) yamls="$yamls $(addyaml $1)" ;;
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

function down(){
    docker compose $yamls down
    docker ps -a --format "{{.Names}}" | grep "^$EDS_CONTAINER_PREFIX-jupyter-" | xargs -r docker rm
}

echo $action | grep -q "\bup\b" && down

