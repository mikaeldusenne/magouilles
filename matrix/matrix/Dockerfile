FROM matrixdotorg/synapse:latest

COPY keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

RUN echo '#!/bin/sh\n\nsleep 16; /start.py' > /start.sh
RUN chmod +x /start.sh
