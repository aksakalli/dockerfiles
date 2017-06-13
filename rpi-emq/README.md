# Raspberry Pi EMQ

[Erlang MQTT Broker (EMQ)](http://emqtt.io/) for Raspberry Pi.

## Usage

You can run it from Docker Hub.

```
docker run --rm -ti --name emq -p 18083:18083 -p 1883:1883 aksakalli/rpi-emq
```

## Building locally

```
docker build -t rpi-emq .
```

(it takes quite some time to build on a Raspberry Pi)
