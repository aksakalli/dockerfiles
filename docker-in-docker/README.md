# Docker in Docker

This is an example Dockerfile to run docker command inside a container. 
It can be used for task runner containers (e.g., Airflow worker, Jenkins CI) where the container needs to create sibling containers.

This Dockerfile downloads docker binaries and keeps only the client cli.
When you run it by mounting the `docker.sock` of the host machine, it can execute any docker command of the host.

## Usage

```
$ docker run -it  -v /var/run/docker.sock:/var/run/docker.sock --rm aksakalli/docker-in-docker bash
```

Now you are inside the docker container that can run the docker command.

```
root@8d1ef7e6299e:/# docker run hello-world
```

or you can list the containers (including the container itself)

```
root@8d1ef7e6299e:/# docker ps -a
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS                          PORTS                                        NAMES
582626c0a47f        hello-world                "/hello"                 5 minutes ago       Exited (0) 5 minutes ago                                                     priceless_benz
8d1ef7e6299e        docker-in-docker           "/bin/bash"              5 minutes ago       Up 6 minutes                                                                 friendly_payne
```

## Building locally

```
$ docker build -t docker-in-docker .
```