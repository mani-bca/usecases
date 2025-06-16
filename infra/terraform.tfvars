lambda_role_name = "lambda-ec2-logs-role"
lambda_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
]
##############api
region                  = "us-east-1"
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