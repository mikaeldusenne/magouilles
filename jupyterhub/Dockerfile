FROM jupyterhub/jupyterhub:latest

RUN pip install oauthenticator
RUN pip install notebook jupyterlab
RUN pip install dockerspawner

RUN mkdir -p /my-certificates/

COPY certificates/jupyterhub.crt /my-certificates/
COPY certificates/jupyterhub.key /my-certificates/

COPY keycloak.crt /usr/local/share/ca-certificates/
COPY gitlab.crt /my-certificates/gitlab.crt

RUN dpkg-reconfigure ca-certificates && \
    update-ca-certificates --fresh

ENV REQUESTS_CA_BUNDLE='/etc/ssl/certs/ca-certificates.crt'
ENV SSL_CERT_FILE='/etc/ssl/certs/ca-certificates.crt'

