user_pool_name = "hello-user-pool"
domain_prefix  = "helloapp"
callback_urls  = ["https://example.com/callback"]
logout_urls    = ["https://example.com/logout"]

lambda_runtime          = "python3.11"
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