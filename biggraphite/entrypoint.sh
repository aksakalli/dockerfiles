#!/usr/bin/env bash


wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}

wait_for_port "Elasticsearch" "elasticsearch" "9200"
wait_for_port "Cassandra" "cassandra" "9042"
bgutil --cassandra_contact_points=cassandra syncdb --storage-schemas storage-schemas.conf

create_keyspace="
from cassandra.cluster import Cluster
cluster = Cluster(['cassandra'])
session = cluster.connect()
q = \"CREATE KEYSPACE IF NOT EXISTS biggraphite WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'} AND durable_writes = false\"
session.execute(q)
cluster.shutdown()
"
# session.execute(open('/conf/schema.cql', 'r').read())

python -c "$create_keyspace"

case "$1" in
  graphite-webapp)
    cp /conf/local_settings.py /usr/local/lib/python3.6/site-packages/graphite/
    django-admin migrate
    django-admin migrate --run-syncdb
    run-graphite-devel-server.py /usr/local
    ;;
  carbon-cache)
    bg-carbon-cache --conf=/conf/carbon.conf start
    ;;
  *)
    # The command is something like bash, just run it
    exec "$@"
    ;;
esac