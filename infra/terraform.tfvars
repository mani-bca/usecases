user_pool_name = "hello-user-pool"
domain_prefix  = "helloappmani"





function_name           = "hello-world-fn"
handler                 = "index.handler"
runtime                 = "nodejs18.x"
source_path             = "../lambda-code"
memory_size             = 128
timeout                 = 30
layers                  = []
environment_variables   = {
  ENV   = "dev"
  DEBUG = "true"
}
architecture            = "arm64"


lambda_role_name        = "api-lambda-role"
lambda_policy_arns      = [
  "arn:aws:iam::aws:policy/AWSLambdaExecute",
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]

tags = {
  Project = "SemanticSearch"
  Env   = "dev"
}