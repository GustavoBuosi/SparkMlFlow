#!/bin/bash

# Original entrypoint
/opt/bitnami/scripts/spark/entrypoint.sh &
SPARK_PID=$!

wait
mvn -f /opt/bitnami/spark/conf/pom.xml dependency:copy-dependencies -DoutputDirectory=/opt/bitnami/spark/jars

wait $SPARK_PID

exec "$@"
