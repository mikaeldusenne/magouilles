FROM jupyter/base-notebook

RUN conda install -c conda-forge jupyterlab jupyterlab-git

###############################################
USER root


RUN apt-get update && \
    apt-get install -y curl iputils-ping dnsutils


RUN apt-get install -y r-base && \
    R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')" && \
    R -e "IRkernel::installspec(user = FALSE)"

RUN apt-get install -y git

RUN mkdir -p /home/jovyan/my_amazing_research_stuff &&\
    chown jovyan:users /home/jovyan/my_amazing_research_stuff

RUN apt-get install -y build-essential libssl-dev libcurl4-openssl-dev libxml2-dev libjpeg-dev libpng-dev libtiff-dev liblapack-dev libblas-dev gfortran libsqlite3-dev libmysqlclient-dev libpq-dev zlib1g-dev

RUN pip install --upgrade pexpect # needed for python 3.11+ support

COPY requirements.txt ./
RUN pip install -r requirements.txt


RUN chown -R jovyan:users /home/jovyan/.local
RUN chown -R jovyan:users /home/jovyan/.ipython

COPY trusted-certs/jupyterhub.crt /usr/local/share/ca-certificates/jupyterhub.crt
COPY trusted-certs/gitlab.crt /usr/local/share/ca-certificates/gitlab.crt
COPY trusted-certs/keycloak.crt /usr/local/share/ca-certificates/keycloak.crt
RUN update-ca-certificates

USER jovyan
###############################################

ENV REQUESTS_CA_BUNDLE='/etc/ssl/certs/ca-certificates.crt'
ENV SSL_CERT_FILE='/etc/ssl/certs/ca-certificates.crt'


