raw_bucket_name         = "semantic-search-raw"
processed_bucket_name   = "semantic-search-processed"

vpc_cidr                = "10.0.0.0/16"
subnet_ids              = ["10.0.1.0/24", "10.0.2.0/24"]

db_name                 = "semanticdb"
db_username             = "postgres"
db_password             = "supersecretpassword"
db_instance_class       = "db.t3.micro"
db_secret_name          = "semantic-search-db-credentials"

lambda_code_bucket      = "lambda-code-bucket"
ingest_lambda_key       = "ingest.zip"
search_lambda_key       = "search.zip"

ingest_lambda_name      = "semantic-ingest"
search_lambda_name      = "semantic-search"
ingest_lambda_handler   = "ingest_lambda.handler"
search_lambda_handler   = "search_lambda.handler"

lambda_runtime          = "python3.11"
lambda_role_name        = "semantic-lambda-role"
lambda_policy_arns      = [
  "arn:aws:iam::aws:policy/AWSLambdaExecute",
  "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
]

api_name                = "semantic-search-api"

tags = {
  Project = "SemanticSearch"
  Owner   = "Manivasagan"
}