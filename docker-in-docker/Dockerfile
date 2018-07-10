FROM ubuntu:16.04
LABEL maintainer "Can Güney Aksakalli <can.aksakalli@rwth-aachen.de>"


RUN apt-get update && apt-get install -y \
  wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR "/tmp/docker-download"

RUN wget -c https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz -O docker.tgz \
  && tar xzvf docker.tgz \
  && cp docker/docker /usr/bin/ \
  && rm -rf /tmp/docker-download

WORKDIR "/home" 
