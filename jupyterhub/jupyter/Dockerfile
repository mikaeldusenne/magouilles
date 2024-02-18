FROM jupyter/base-notebook

RUN conda install -c conda-forge jupyterlab jupyterlab-git

###############################################
USER root


RUN apt-get update && \
    apt-get install -y curl iputils-ping


RUN apt-get install -y r-base && \
    R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')" && \
    R -e "IRkernel::installspec(user = FALSE)"

RUN apt-get install -y git


RUN chown -R jovyan:users /home/jovyan/.local
RUN chown -R jovyan:users /home/jovyan/.ipython

COPY jupyterhub.crt /usr/local/share/ca-certificates/jupyterhub.crt
COPY gitlab.crt /usr/local/share/ca-certificates/gitlab.crt
COPY keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

USER jovyan
###############################################

ENV REQUESTS_CA_BUNDLE='/etc/ssl/certs/ca-certificates.crt'
ENV SSL_CERT_FILE='/etc/ssl/certs/ca-certificates.crt'


RUN pip install --upgrade pexpect # needed for python 3.11+ support

COPY requirements.txt ./
RUN pip install -r requirements.txt

