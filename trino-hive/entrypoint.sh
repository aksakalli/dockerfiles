#!/bin/bash

/etc/init.d/postgresql start

minio server /data --console-address ":9001" &

echo "run schema init for hive-metastore in postgres"
schematool -initSchema -dbType postgres
start-metastore &

echo "start trino"
launcher start &

# Wait and exit if any process fails
wait -n
exit $?


