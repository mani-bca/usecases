user_pool_name = "hello-user-pool"
domain_prefix  = "helloapp"
callback_urls  = ["https://example.com/callback"]
logout_urls    = ["https://example.com/logout"]



function_name           = "hello-world-fn"
handler                 = "index.handler"
runtime                 = "nodejs18.x"
source_path             = "../../lambda-code"
memory_size             = 512
timeout                 = 10
layers                  = ["arn:aws:lambda:us-east-1:123456789012:layer:custom-lib:1"]
environment_variables   = {
  ENV   = "dev"
  DEBUG = "true"
}
architecture            = "arm64"

lambda_role_name        = "lambda-exec-role"
lambda_policy_arns      = [
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]



lambda_role_name        = "semantic-lambda-role"
lambda_policy_arns      = [
  "arn:aws:iam::aws:policy/AWSLambdaExecute",
  "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
]

tags = {
  Project = "SemanticSearch"
  Env   = "dev"
}