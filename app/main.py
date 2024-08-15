from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler, StringIndexer, OneHotEncoder 
from pyspark.ml import Pipeline 
from pyspark.ml.classification import LogisticRegression
import mlflow.pyfunc

spark: SparkSession =  SparkSession.builder.appName('titanic').getOrCreate()
df = spark.read.csv('s3a://datalake/raw/titanic/*.csv', inferSchema=True, header=True)
mlflow.set_tracking_uri("http://host.docker.internal:5000")
# print(spark.sparkContext.getConf().getAll())

rm_columns = df.select(['Survived','Pclass', 
                       'Sex','Age','SibSp', 
                       'Parch','Fare','Embarked']) 
  
# Drops the data having null values 
result = rm_columns.na.drop() 

sexIdx = StringIndexer(inputCol='Sex', 
                               outputCol='SexIndex') 
sexEncode = OneHotEncoder(inputCol='SexIndex', 
                               outputCol='SexVec') 
  
embarkIdx = StringIndexer(inputCol='Embarked', 
                               outputCol='EmbarkIndex') 
embarkEncode = OneHotEncoder(inputCol='EmbarkIndex', 
                               outputCol='EmbarkVec') 

assembler = VectorAssembler(inputCols=['Pclass', 
                                       'SexVec','Age', 
                                       'SibSp','Parch', 
                                       'Fare','EmbarkVec'], 
                                    outputCol='features')

log_reg = LogisticRegression(featuresCol='features', 
                             labelCol='Survived') 
  
# Creating the pipeline
pipeline = Pipeline(stages=[sexIdx, embarkIdx, 
                            sexEncode, embarkEncode, 
                            assembler, log_reg])


train_data, test_data = result.randomSplit([0.7, .3])

# prediction = fit_model.transform(test_data)

# prediction.show()

with mlflow.start_run() as run:
   fit_model = pipeline.fit(train_data)
   mlflow.spark.log_model(fit_model, "spark-model")
   mlflow.log_param("max_iter", 10)
   mlflow.log_metric("accuracy", 0.8)
   model_uri = mlflow.get_artifact_uri("spark-model")
   print(f"Model saved in run {run.info.run_id} at {model_uri}")
