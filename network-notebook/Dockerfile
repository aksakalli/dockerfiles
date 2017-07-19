FROM jupyter/scipy-notebook
LABEL maintainer "Can Güney Aksakalli <can.aksakalli@rwth-aachen.de>"

USER root

RUN wget https://snap.stanford.edu/snappy/release/snap-3.0.2-3.0-centos6.5-x64-py2.6.tar.gz -O snap.tar.gz \
    && tar xf snap.tar.gz && rm snap.tar.gz \
    && cd snap-3.0.2-3.0-centos6.5-x64-py2.6/ \
    # && python2 setup.py install \
    && pip2 install . \
    && cd .. && rm -rf snap-3.0.2-3.0-centos6.5-x64-py2.6


USER $NB_USER
RUN pip2 install pymongo
