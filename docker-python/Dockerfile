from python:3.11

RUN apt-get update && apt-get upgrade -y

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
# COPY requirements.txt ./requirements.txt
# RUN pip install -r requirements.txt

RUN pip install requests

WORKDIR /app

ENTRYPOINT python
