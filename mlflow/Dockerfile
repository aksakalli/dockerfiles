FROM continuumio/miniconda3

RUN conda install --yes -c conda-forge mlflow

WORKDIR /

RUN mkdir /mlruns
VOLUME /mlruns
EXPOSE 5000

ENTRYPOINT ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]
