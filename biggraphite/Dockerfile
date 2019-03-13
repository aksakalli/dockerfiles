FROM python:3.6-jessie

ENV GRAPHITE_NO_PREFIX=true
ENV DJANGO_SETTINGS_MODULE=graphite.settings

RUN apt-get update && apt-get install -y \
  netcat \
  && rm -rf /var/lib/apt/lists/*

RUN pip install carbon biggraphite graphite-web

COPY entrypoint.sh /entrypoint.sh
COPY conf /conf
EXPOSE 2003-2004 2013-2014 2023-2024 8080 8125 8125/udp 8126

ENTRYPOINT ["/entrypoint.sh"]