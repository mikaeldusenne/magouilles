FROM gitlab/gitlab-ce:latest

RUN mkdir -p /etc/gitlab/trusted-certs/

COPY certificates/jupyterhub.crt /etc/gitlab/trusted-certs/
COPY certificates/keycloak.crt /etc/gitlab/trusted-certs/

