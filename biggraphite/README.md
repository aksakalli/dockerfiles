# BigGraphite (work in progress)

A scalable [Graphite](https://graphite.readthedocs.io/en/latest/) installation using [BigGraphite](https://github.com/criteo/biggraphite) carbon plugin.
It uses Cassandra for the storage layer.

The `docker-compose` file includes Cassandra and Elasticsearch images to run it.

```
wget https://raw.githubusercontent.com/aksakalli/dockerfiles/master/biggraphite/docker-compose.yml
docker-compose up -d
```

You can access the graphite server at `localhost:8080` and publish the metrics to graphite at `localhost:2003`

## Troubleshooting

The Elasticsearch container might fail to start due to `vm.max_map_coun` 
setting of the kernel which needs to be set at least `262144`. 
To apply this, type `$ sysctl -w vm.max_map_count=262144` (in Linux).

## Building the image locally

```
docker build -t aksakalli/biggraphite .
```