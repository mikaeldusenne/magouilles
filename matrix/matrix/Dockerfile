FROM matrixdotorg/synapse:latest

COPY keycloak.crt.pem /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

COPY ./tmp/client.py /usr/local/lib/python3.11/site-packages/synapse/http/client.py

RUN echo '#!/bin/sh\n\nsleep 16; /start.py' > /start.sh
RUN chmod +x /start.sh
