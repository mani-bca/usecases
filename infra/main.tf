module "iam_role" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/iam_entity?ref=main"

  name                 = var.name
  type                 = var.type
  trust_policy_json    = file("${path.module}/trust_policy.json")
  aws_managed_policy_arns = var.aws_managed_policy_arns
  inline_policies      = {
    "lambda-inline-policy" = "${path.module}/lambda_ec2_logs_policy.json"
  }
}

module "lambda_docker" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/lambda_docker?ref=main"

  function_name         = var.function_name
  role_arn              = module.iam_role.iam_role_arn
  image_uri             = var.image_uri
  timeout               = var.timeout
  memory_size           = var.memory_size
  architectures         = var.architectures
  environment_variables = var.environment_variables
  tags                  = var.tags
}

module "api_gateway" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/api_gateway?ref=main"
  api_name          = var.api_name
  description       = var.description
  resource_path     = var.resource_path
  http_method       = var.http_method
  authorization     = var.authorization
  lambda_invoke_arn = module.lambda_docker.lambda_invoke_arn
  stage_name        = var.stage_name
  region            = var.region
  lambda_function_name = module.lambda_docker.function_name
}

# Read the lifecycle policy from external JSON file
locals {
  lifecycle_policy = fileexists("${path.module}/ecr_lifecycle_policy.json") ? file("${path.module}/ecr_lifecycle_policy.json") : null
}

#module "ecr" {
#  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ecr?ref=main"
#
#  repository_name     = var.repository_name
#  image_tag_mutability = var.image_tag_mutability
#  scan_on_push        = var.scan_on_push
#  tags                = var.tags
#  lifecycle_policy    = local.lifecycle_policy
#}
