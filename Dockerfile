FROM bitnami/spark:3.5.2

USER root

ENV SPARK_HOME=/opt/bitnami/spark
ENV PATH="${SPARK_HOME}/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y maven
    # apt-get install -y maven python3-pip

COPY spark-data ${SPARK_HOME}/tmp/spark
COPY conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
COPY conf/pom.xml ${SPARK_HOME}/conf/pom.xml
COPY scripts ${SPARK_HOME}/scripts
RUN mvn -f ${SPARK_HOME}/conf/pom.xml dependency:copy-dependencies -DoutputDirectory=${SPARK_HOME}/jars

COPY requirements.txt ${SPARK_HOME}/requirements.txt
RUN pip install -r ${SPARK_HOME}/requirements.txt

RUN chmod +x ${SPARK_HOME}/scripts/start-spark.sh
