FROM debian:jessie
LABEL maintainer "Can Güney Aksakalli <can.aksakalli@rwth-aachen.de>"

RUN apt-get update && apt-get install -y \
  texlive-full \
  texlive-bibtex-extra \
  python-pygments gnuplot \
  biber \
  git make vim

ADD sample /workspace/sample
WORKDIR /workspace

VOLUME ["/workspace"]
