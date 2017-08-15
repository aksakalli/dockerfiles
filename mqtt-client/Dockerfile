FROM alpine:3.6
LABEL maintainer "Can Güney Aksakalli <can.gueney.aksakalli@fit.fraunhofer.de>"

COPY ./publish.sh /bin/publish

RUN apk add --update \
    mosquitto-clients \
    openssl \
    curl \
    && ln -s /usr/bin/mosquitto_pub /usr/local/bin/pub \
    && ln -s /usr/bin/mosquitto_sub /usr/local/bin/sub \
    && chmod +x /bin/publish
