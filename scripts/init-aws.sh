#!/bin/bash
awslocal s3 mb s3://datalake
awslocal s3 mb s3://mlflow
awslocal s3 cp /input-data/datalake s3://datalake --recursive
awslocal s3 cp /input-data/mlflow s3://mlflow --recursive
