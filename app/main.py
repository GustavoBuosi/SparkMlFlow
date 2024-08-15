from pyspark.sql import SparkSession


spark: SparkSession =  SparkSession.builder.appName('abc').getOrCreate()
df = spark.read.csv('s3a://datalake/raw/*.csv')

# print(spark.sparkContext.getConf().getAll())

df.show()