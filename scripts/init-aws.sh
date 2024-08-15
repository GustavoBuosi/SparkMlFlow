#!/bin/bash
awslocal s3 mb s3://datalake
awslocal s3 cp /input-data s3://datalake --recursive