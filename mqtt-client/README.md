# MQTT Client

A lightweight Alpine based MQTT client.

#### Connecting to a broker:

```
docker run -it --rm \
  aksakalli/mqtt-client \
  sub -h test.mosquitto.org -t "#" -v
```

#### Connecting to another broker container named `mqtt-broker`:

```
docker run -it --rm \
  --link mqtt-broker  \
  aksakalli/mqtt-client \
  sub -h mqtt-broker -t "#" -v
```

#### Publish messages

```
docker run -d --rm \
  --link mqtt-broker  \
  aksakalli/mqtt-client \
  pub -h mqtt-broker -t "/test" -m "Hello World!"
```

#### BONUS

Publish test SenML messages every second like:

```json
{
    "e": [{
        "v": 19181 //Random number
    }],
    "bn": "dev1",
    "bt": "1502834003" //Current timestamp
}
```

by running the bash script `publish.sh`:

```
docker run -it --rm \
  --link mqtt-broker \
  aksakalli/mqtt-client \
  publish
```
