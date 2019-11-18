# MLflow

Conda based docker image for [MLflow](https://www.mlflow.org/).

## Usage

Starting the logging server.

```bash
docker run -it --rm --nmae mlflow -p 5000:5000 -v $(pwd)/mlruns:/mlruns aksakalli/mlflow
```

You can use the remote MLflow server to log experiments from anywhere:

```python
import mlflow

# change the host depending on where the docker image is running
mlflow.set_tracking_uri("http://localhost:5000/")

mlflow.set_experiment("/my-experiment")
with mlflow.start_run():
    mlflow.log_param("a", 1)
    mlflow.log_metric("b", 2)
```

You can run mlflow projects inside the container as well.

```bash
docker exec -it mlflow mlflow run https://github.com/mlflow/mlflow-example.git -P alpha=0.5
```
