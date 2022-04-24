#!/bin/bash

/etc/init.d/postgresql start

start-metastore &

minio server /data --console-address ":9001" &

launcher start

# Wait and exit if any process fails
wait -n
exit $?
