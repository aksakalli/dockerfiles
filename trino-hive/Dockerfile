FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
  curl \
  openjdk-11-jdk \
  postgresql-12 \
  python3 \
  && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
RUN ln -s /usr/bin/python3 /usr/bin/python && \
  ln -s /usr/bin/pip3 /usr/bin/pip

# Minio
RUN curl https://dl.min.io/server/minio/release/linux-amd64/minio -o minio && \
  chmod +x minio && \
  mv minio /usr/local/bin/ && \
  mkdir /data
ENV MINIO_ROOT_USER=minio
ENV MINIO_ROOT_PASSWORD=minio123
EXPOSE 9000 9001
VOLUME /data

# POSTGRES
USER postgres
RUN /etc/init.d/postgresql start && \
  psql --command "CREATE USER trino WITH SUPERUSER PASSWORD 'trino';" && \
  createdb -O trino trino
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf
USER root
EXPOSE 5432

# HIVE METASTORE
WORKDIR /opt
ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin
ENV HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar

RUN curl -L https://archive.apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
  curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
  curl -L https://jdbc.postgresql.org/download/postgresql-42.3.4.jar -o ${HIVE_HOME}/lib/postgresql-42.3.4.jar
ENV PATH="${HIVE_HOME}/bin:${PATH}"
COPY metastore-site.xml ${HIVE_HOME}/conf
EXPOSE 9083

# TRINO
ENV TRINO_VERSION=377
ENV TRINO_HOME=/opt/trino-server-${TRINO_VERSION}
RUN curl -L https://repo1.maven.org/maven2/io/trino/trino-server/${TRINO_VERSION}/trino-server-${TRINO_VERSION}.tar.gz | tar zxf -
ENV PATH="${TRINO_HOME}/bin:${PATH}"
COPY trino-etc ${TRINO_HOME}/etc
EXPOSE 8080

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
