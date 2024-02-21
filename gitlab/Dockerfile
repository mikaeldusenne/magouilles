FROM gitlab/gitlab-ce:latest

RUN mkdir -p /etc/gitlab/trusted-certs/

COPY jupyterhub.crt /etc/gitlab/trusted-certs/
COPY keycloak.crt /etc/gitlab/trusted-certs/

# COPY keycloak.crt /etc/gitlab/ssl/
# COPY jupyterhub.crt /etc/gitlab/ssl/
# # /usr/local/share/ca-certificates/keycloak.crt
# RUN cp /etc/gitlab/ssl/keycloak.crt /usr/local/share/ca-certificates/ && \
#     cp /etc/gitlab/ssl/jupyterhub.crt /usr/local/share/ca-certificates/ && \
#     update-ca-certificates
