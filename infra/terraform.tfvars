region                  = "us-east-1"
lambda_role_name = "lambda-ec2-logs-role"
lambda_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]
#####lambda
function_name = "upload-lambda"
image_uri     = "676206899900.dkr.ecr.us-east-1.amazonaws.com/dev/lambda:uploadapp"
timeout       = 30
memory_size   = 128

architectures = ["x86_64"]

environment_variables = {
  ENV = "prod"
  LOG_LEVEL = "debug"
}

##############api
name                    = "my-rest-api"
description             = "Generic REST API Gateway"
endpoint_types          = ["REGIONAL"]
path_part               = "hello"
http_method             = "GET"
authorization           = "NONE"
integration_http_method = "POST"
integration_type        = "MOCK"
integration_uri         = ""
stage_name              = "dev"
#####################tags
tags = {
  Environment = "production"
  Project     = "my-app"
  Owner       = "devops-team"
}