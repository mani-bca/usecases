output "role_arn" {
  value = module.lambda_iam_role.iam_role_arn
}

# output "function_name" {
#   value = module.lambda_docker.function_name
# }

# output "lambda_arn" {
#   value = module.lambda_docker.lambda_arn
# }

# output "lambda_invoke_arn" {
#   value = module.lambda_docker.lambda_invoke_arn
# }

########api_gateway

output "api_gateway_id" {
  value = module.api_gateway.rest_api_id
}

output "invoke_url" {
  value = module.api_gateway.invoke_url
}