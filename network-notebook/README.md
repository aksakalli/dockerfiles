# Network Notebook

Some additional stuff (like [snap](http://snap.stanford.edu/)) on top of
[jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook)
for network analysis.

## Usage

```
docker run -it --rm -p 8888:8888 network-notebook
```

or if you have Mongo data source:

```
docker run -it --rm -p 8888:8888 --link my-mongo network-notebook
```

if you need to install additional OS packages, add `-e GRANT_SUDO=yes` for passwordless sudo.

Go to [jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook) for more detailed options.
