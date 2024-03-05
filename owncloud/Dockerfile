FROM owncloud/server:latest

COPY trusted-certs/keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

