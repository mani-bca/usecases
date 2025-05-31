######iam_entity
name = "lambda-ec2-logs-role"
type = "role"
aws_managed_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]
#####lambda
function_name = "my-docker-lambda"
#role_arn      = "arn:aws:iam::123456789012:role/my_lambda_exec_role"
image_uri     = "676206899900.dkr.ecr.us-east-1.amazonaws.com/dev/lambda:latest"
timeout       = 30
memory_size   = 128

architectures = ["x86_64"]

environment_variables = {
  ENV = "prod"
  LOG_LEVEL = "debug"
}

#tags = {
#  Project = "lambda-docker"
#  Owner   = "Manivasagan"
#}
###api_gateway

region             = "us-east-1"
api_name           = "lambda-api"
description        = "Docker API Gateway"
resource_path      = "testhello"
http_method        = "GET"
authorization      = "NONE"
#lambda_invoke_arn  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:my-lambda/invocations"
stage_name         = "dev"

########ecr
#repository_name     = "my-application"
#image_tag_mutability = "IMMUTABLE"
#scan_on_push        = true

tags = {
  Environment = "production"
  Project     = "my-app"
  Owner       = "devops-team"
}