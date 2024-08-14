from pyspark.sql import SparkSession


spark: SparkSession =  SparkSession.builder.appName('abc').getOrCreate()
df = spark.range(10)
df.show()