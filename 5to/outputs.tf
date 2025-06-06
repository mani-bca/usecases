output "iam_role_arn" {
  value = module.lambda_iam_role.arn
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

# output "api_gateway_url" {
#   value = module.api_gateway.api_invoke_url
# }