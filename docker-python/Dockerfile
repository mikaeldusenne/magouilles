from python:3.11

RUN apt-get update && apt-get upgrade -y

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip && pip install requests pyyaml

WORKDIR /app

ENTRYPOINT python
