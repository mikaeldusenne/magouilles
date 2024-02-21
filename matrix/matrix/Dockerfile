FROM matrixdotorg/synapse:latest

COPY trusted-certs/keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

COPY ./synapse_http_client_patched.py /usr/local/lib/python3.11/site-packages/synapse/http/client.py

RUN echo '#!/bin/sh\n\nsleep 32; /start.py' > /start.sh
RUN chmod +x /start.sh
