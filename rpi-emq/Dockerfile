FROM resin/rpi-raspbian:wheezy
LABEL maintainer "Can Güney Aksakalli <can.aksakalli@rwth-aachen.de>"
LABEL description "EMQ for Raspberry Pi: It builds EMQ and removes deps"

# Intalling Erlang Environment
# Based on https://github.com/joakimk/rpi-erlang

ENV ERLANG_VERSION=18.1.3 \
    ERLANG_SHA=e014f4248b113698ca35412fde22646f5aab804b5e1f338d21345414d244d467

ENV DEBIAN_FRONTEND=noninteractive \
    OTP_VERSION=OTP-${ERLANG_VERSION} \
    OTP_DOWNLOAD_SHA=${ERLANG_SHA} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

ENV BUILD_PACKAGES \
      locales \
      build-essential \
      autoconf \
      libncurses5-dev \
      libssl-dev \
      curl \
      ca-certificates \
      procps \
      git

RUN apt-get update && apt-get install -y \
    $BUILD_PACKAGES \
    --no-install-recommends

RUN export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN set -xe \
    && curl -SL https://github.com/erlang/otp/archive/${OTP_VERSION}.tar.gz -o otp-src.tar.gz \
    && echo "${OTP_DOWNLOAD_SHA}  otp-src.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/otp-src \
    && tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure \
    && make -j $(nproc) \
    && make install \
    && rm -rf /usr/src/otp-src


# Now compile EMQ Project

ENV EMQ_VERSION=v2.2-beta.3

COPY ./start.sh /start.sh

RUN git clone -b ${EMQ_VERSION} https://github.com/emqtt/emq-relx.git /emqttd \
    && cd /emqttd \
    && make \
    && mkdir -p /opt && mv /emqttd/_rel/emqttd /opt/emqttd \
    && cd / && rm -rf /emqttd \
    && mv /start.sh /opt/emqttd/start.sh \
    && chmod +x /opt/emqttd/start.sh \
    && ln -s /opt/emqttd/bin/* /usr/local/bin/

# remove some unused build deps to reduce the package size
RUN apt-get remove -qq --purge -y $BUILD_PACKAGES \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/local/lib/erlang


WORKDIR /opt/emqttd

# start emqttd and initial environments
CMD ["bash /opt/emqttd/start.sh"]

VOLUME ["/opt/emqttd/log", "/opt/emqttd/data", "/opt/emqttd/lib", "/opt/emqttd/etc"]

# emqttd will occupy these port:
# - 1883 port for MQTT
# - 8883 port for MQTT(SSL)
# - 8083 for WebSocket/HTTP
# - 8084 for WSS/HTTPS
# - 18083 for dashboard
# - 4369 for port mapping
# - 6000-6999 for distributed node
EXPOSE 1883 8883 8083 8084 18083 4369 6000-6999
