FROM bitnami/spark:3.5.2

USER root

ENV SPARK_HOME=/opt/bitnami/spark
ENV PATH="${SPARK_HOME}/bin:${PATH}"

RUN apt-get update
RUN apt-get -y install maven

COPY spark-data /tmp/spark
COPY conf/spark-defaults.conf /opt/bitnami/spark/conf/spark-defaults.conf
COPY conf/pom.xml /opt/bitnami/spark/conf/pom.xml
COPY scripts /opt/bitnami/spark/scripts

RUN chmod +x /opt/bitnami/spark/scripts/start-spark.sh

RUN mvn -f /opt/bitnami/spark/conf/pom.xml dependency:copy-dependencies -DoutputDirectory=/opt/bitnami/spark/jars

# ENTRYPOINT ["/opt/bitnami/scripts/spark/entrypoint.sh"]
