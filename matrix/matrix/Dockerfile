FROM matrixdotorg/synapse:latest

RUN mkdir -p /my-ssl-certs/
COPY certificates/matrix.crt /my-ssl-certs/
COPY certificates/matrix.key /my-ssl-certs/
RUN chown -R 991:991 /my-ssl-certs/

COPY trusted-certs/keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

COPY ./synapse_http_client_patched.py /usr/local/lib/python3.11/site-packages/synapse/http/client.py

RUN echo '#!/bin/sh\n\nsleep 32; /start.py' > /start.sh
RUN chmod +x /start.sh
