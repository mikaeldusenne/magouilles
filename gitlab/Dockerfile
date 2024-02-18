FROM gitlab/gitlab-ce:latest

RUN mkdir -p /etc/gitlab/trusted-certs/
COPY keycloak.crt /etc/gitlab/trusted-certs/
COPY jupyterhub.crt /etc/gitlab/trusted-certs/

