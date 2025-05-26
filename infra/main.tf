module "lambda_iam_role" {
  source         = "../modules/iam_role"
  role_name      = var.lambda_role_name
  policy_arns    = var.lambda_policy_arns
  tags           = var.tags
}

module "lambda_hello" {
  source         = "../modules/lambda"
  function_name  = var.function_name
  handler        = var.handler
  runtime        = var.runtime
  role_arn       = module.lambda_iam_role.iam_role_arn
  source_path    = var.source_path
  memory_size    = var.memory_size
  timeout        = var.timeout
  layers         = var.layers
  environment_variables = var.environment_variables
  architecture   = var.architecture
  depends_on = [
    module.lambda_iam_role
  ]
}

module "api_gateway" {
  source     = "../modules/api_gateway"
  api_name   = "hello-api"
  stage_name = "prod"
  region     = var.region

  routes = {
    "GET /hello" = {
      lambda_arn = module.lambda_hello.lambda_arn
    }
  }
  depends_on = [
    module.lambda_hello
  ]
}

module "cognito" {
  source         = "../modules/cognito"
  user_pool_name = var.user_pool_name
  domain_prefix  = var.domain_prefix
  callback_urls  = [module.api_gateway.invoke_url]
  logout_urls    = var.logout_urls
  depends_on = [
    module.api_gateway
  ]
}


# module "api_gateway" {
#   source     = "../../modules/api_gateway"
#   api_name   = "hello-api"
#   stage_name = "prod"
#   region     = var.region

#   routes = {
#     "GET /hello" = {
#       lambda_arn = module.lambda_hello.lambda_arn
#     },
#     "GET /bye" = {
#       lambda_arn = module.lambda_bye.lambda_arn
#     }
#   }
# }
