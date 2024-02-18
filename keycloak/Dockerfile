FROM keycloak/keycloak:latest
    # as builder

# Enable health and metrics support
# ENV KC_HEALTH_ENABLED=true
# ENV KC_METRICS_ENABLED=true


WORKDIR /opt/keycloak

COPY certificates/keycloak.p12 /etc/x509/https/server.p12

###################################
USER root

RUN keytool -importkeystore -deststorepass password -destkeystore conf/server.keystore -srckeystore /etc/x509/https/server.p12 -srcstoretype PKCS12 -srcstorepass changeit -alias server

COPY gitlab.crt /etc/x509/https/
RUN keytool -import -trustcacerts -alias gitlab -file /etc/x509/https/gitlab.crt -keystore conf/server.keystore -storepass password -noprompt

COPY jupyterhub.crt /etc/x509/https/
RUN keytool -import -trustcacerts -alias jupyterhub -file /etc/x509/https/jupyterhub.crt -keystore conf/server.keystore -storepass password -noprompt

USER keycloak
###################################

