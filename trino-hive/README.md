# Trino Hive

Self contained docker image for testing and demo purposes.
Trino installation with Hive Metastore and Minio filesystem.
This image is not for Trino deployments in production.
It's advisable to use the official Docker images separately and configure.
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
     |              |
     |  +-----------+
     |  |
     V  V
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

## Demo

Start the container.

```bash
docker run -d -p 8080:8080 -p 5432:5432 -p 9083:9083 -p 9000:9000 -p 9001:9001 --name trino-hive aksakalli/trino-hive
```

Use docker exec to run commands inside the container and create a bucket folder for minio.

```bash
docker exec -it trino-hive bash
mkdir /data/testbucket
```

You can alternatively create and browse the minio buckets via the Minio web UI exposed at http://localhost:9001 with user: `minio` & password: `minio123`.

### Hive Catalog

`trino-hive` image contains Trino CLI tool.
Run the `trino` command inside the container and run the following SQL statement to create a schema.

```sql
CREATE SCHEMA hive.test WITH (location = 's3a://testbucket/');
```

You can view the running queries in the Trino Web UI exposed at http://localhost:8080.

This schema is created under the `hive` catalog.
The catalogs are defined and configured under the [catalog](trino-etc/catalog) folder.
`SHOW CATALOGS;` statement lists available schemas in Trino.

Create a table by selecting from [tpch](https://www.tpc.org/tpch/) catalog.
This catalog provides schemas with generated data for benchmarking.

```sql
CREATE TABLE hive.test.customer
WITH (format='parquet', external_location = 's3a://testbucket/customer/')
AS SELECT * FROM tpch.tiny.customer;
```

You can find the parquet files generated under this path and
the table is accessible from a select statement.

```sql
SELECT * FROM hive.test.customer LIMIT 50;
```

This example creates a parquet table however Trino's [Hive connector](https://trino.io/docs/current/connector/hive.html) 
supports many other file formats.

### Metastore Catalog

The table creation process stores the table definition into the database of Hive Metastore.
This container is configured to access this database via Trino's [PostgreSQL connector](https://trino.io/docs/current/connector/postgresql.html).
You can see the available tables for this Hive Metastore with `SHOW TABLES in metastore.public;` statement.
`dbs` table shows all Hive databases.

```sql
SELECT * FROM  metastore.public.dbs;
```
This is showing the schema that we created.
`tbls` stores the tables.
We can list databases and tables under with a join.

```sql
SELECT d.name, t.tbl_name, t.tbl_type, t.owner
FROM metastore.public.tbls t
JOIN metastore.public.dbs d ON t.db_id=d.db_id;
```
Location is stored in `sds` table and "serde" (serializer/deserializer) information in `serdes` table.
We can list this information with two join statement.

```sql
SELECT t.tbl_name, s.input_format, s.location, se.name, se.slib
FROM metastore.public.tbls t
JOIN metastore.public.sds s ON t.sd_id=s.sd_id
JOIN metastore.public.serdes se ON s.serde_id = se.serde_id;
```

Following metadata query lists the columns for our table `hive.test.customer`.

```sql
SELECT c.*
FROM metastore.public.tbls t
JOIN metastore.public.dbs d ON t.db_id = d.db_id
JOIN metastore.public.sds s ON t.sd_id = s.sd_id
JOIN metastore.public.columns_v2 c ON s.cd_id = c.cd_id
WHERE t.tbl_name = 'customer' AND d.NAME='test'
ORDER by cd_id, integer_idx;
```

### Delta Catalog

The container also configured for delta-lake connector in `delta` catalog.
Create a schema under `delta` catalog.

```sql
CREATE SCHEMA delta.myschema WITH (location='s3a://testbucket/myschema');
```

Create a table, insert some records, and then verify:

```sql
CREATE TABLE delta.myschema.mytable (name varchar, id integer);
INSERT INTO delta.myschema.mytable VALUES ('John', 1), ('Jane', 2);
SELECT * FROM delta.myschema.mytable;
```

That's all for this demo.
Go to [the Trino documentation](https://trino.io/docs/current/) to discover more.

```bash
# stop and remove the container
docker stop trino-hive && docker rm trino-hive

# optionally remove the image
docker rmi aksakalli/trino-hive
```