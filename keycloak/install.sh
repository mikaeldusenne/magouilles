#!/bin/bash

mkdir -p ./config/keycloak

# set up realm and OIDC clients
./start.sh network keycloak keycloak_realm_initialize
