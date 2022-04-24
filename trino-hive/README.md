# Trino Hive

Self contained docker image for testing and demo purposes.
Trino installation with Hive Metastore and Minio filesystem.
This image is not for Trino deployments in production.
It's advisable to use the official Docker images separately and configure it.
This work is inspired by "[A gentle introduction to the Hive connector](https://trino.io/blog/2020/10/20/intro-to-hive-connector.html)".

```
      O
     /|\
     / \
      |
      | Query
      V
  +-------+     +-----------+    +----------+
  |       |     |   Hive    |    | Postgres |
  | Trino |---->| Metastore |--->| Database |
  |       |     |           |    |          |
  +-------+     +-----------+    +----------+
      |
      |
      V
  +-------+
  | Minio |
  | Files |
  +-------+    
```

## How to Build and Run

Build the image yourself or pull it from dockerhub.

```bash
docker build -t aksakalli/trino-hive .
```

Run with some exposed ports for debugging purpose:

```bash
docker run --rm -it \
  -p 8080:8080 \  # Trino
  -p 5432:5432 \  # Postgres
  -p 9083:9083 \  # Hive Metastore
  -p 9000:9000 \  # Minio
  -p 9001:9001 \  # Minio Web Console
  aksakalli/trino-hive
```

docker run --rm -it -p 8080:8080 -p 5432:5432 -p 9083:9083 -p 9000:9000 -p 9001:9001 aksakalli/trino-hive
