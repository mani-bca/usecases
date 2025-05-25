module "lambda_iam_role" {
  source         = "../modules/iam_role"
  role_name      = var.lambda_role_name
  policy_arns    = var.lambda_policy_arns
  tags           = var.tags
}


module "api_gateway" {
  source     = "../../modules/api_gateway"
  api_name   = "hello-api"
  stage_name = "prod"
  region     = var.region

  routes = {
    "GET /hello" = {
      lambda_arn = module.lambda_hello.lambda_arn
    },
    "GET /bye" = {
      lambda_arn = module.lambda_bye.lambda_arn
    }
  }
}

module "cognito" {
  source         = "../../modules/cognito_sso"
  user_pool_name = var.user_pool_name
  domain_prefix  = var.domain_prefix
  callback_urls  = var.callback_urls
  logout_urls    = var.logout_urls
}