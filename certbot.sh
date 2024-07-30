#!/bin/bash

source .env

certbot --nginx -d $EDS_DOMAIN -d chat.$EDS_DOMAIN -d jupyter.$EDS_DOMAIN -d gitlab.$EDS_DOMAIN -d matrix.$EDS_DOMAIN -d keycloak.$EDS_DOMAIN  -d meet.$EDS_DOMAIN -d drive.$EDS_DOMAIN

