#!/bin/sh


host=${MQTT_HOST:-mqtt-broker}
topic=${MQTT_TOPIC:-"/testing/generator"}


while :
do
  mosquitto_pub -h "$host" -t $topic/dev1 -m "{ \"e\":[{\"v\":$RANDOM}], \"bn\" : \"dev1\", \"bt\"
:\"$(date  +%s)\"}"
  mosquitto_pub -h "$host" -t $topic/dev2 -m "{ \"e\":[{\"v\":$RANDOM}], \"bn\" : \"dev2\", \"bt\"
:\"$(date  +%s)\"}"
  sleep 1
done
