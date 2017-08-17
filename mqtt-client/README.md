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

Publish dummy [OGC SensorThings](http://docs.opengeospatial.org/is/15-078r6/15-078r6.html) _Observation_ every second like:

```json
{
  "Datastream":{  
    "@iot.id":"1"
  },
  "result":42,
  "resultTime":"2017-08-17T15:43:59Z"
}
```


by running the bash script `publish.sh`:

```
docker run -it --rm \
  --link mqtt-broker \
  aksakalli/mqtt-client \
  publish
```
