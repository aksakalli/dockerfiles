#!/bin/sh


host=${MQTT_HOST:-mqtt-broker}
topic=${MQTT_TOPIC:-"/testing/generator"}


while :
do
  mes1="{ \"Datastream\": { \"@iot.id\": \"1\"}, \"result\": $RANDOM, \"resultTime\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}"
  mes2="{ \"Datastream\": { \"@iot.id\": \"2\"}, \"result\": $RANDOM, \"resultTime\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}"

  mosquitto_pub -h "$host" -t $topic/dev1 -m "$mes1"
  mosquitto_pub -h "$host" -t $topic/dev2 -m "$mes2"

  sleep 1
done
