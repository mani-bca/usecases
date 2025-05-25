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

