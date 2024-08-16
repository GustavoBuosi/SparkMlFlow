docker-build:
	docker build -t spark-mlflow:0.0.1 .

# FIXME: as of now we need to put this in the spark-submit task
spark-submit:
	docker exec spark spark-submit \
  		--conf spark.hadoop.fs.s3a.access.key=test \
  		--conf spark.hadoop.fs.s3a.secret.key=test \
  		--conf spark.hadoop.fs.s3a.endpoint=http://localstack:4566 \
  		--conf spark.hadoop.fs.s3a.connection.maximum=100 \
		--conf spark.executorEnv.MLFLOW_TRACKING_URI=http://mlflow:5000 \
		--conf spark.driverEnv.MLFLOW_TRACKING_URI=http://mlflow:5000 \
  		--master local[*] \
  	/opt/bitnami/spark/app/main.py

list-mlflow-models:
	awslocal s3 ls mlflow/PRE\ models/
