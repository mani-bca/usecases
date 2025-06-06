# module "iam_role" {
#   source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/iam_entity?ref=main"

#   name                 = var.name
#   type                 = var.type
#   trust_policy_json    = file("${path.module}/trust_policy.json")
#   aws_managed_policy_arns = var.aws_managed_policy_arns
#   inline_policies      = {
#     "lambda-inline-policy" = "${path.module}/lambda_ec2_logs_policy.json"
#   }
# }

module "lambda_iam_role" {
  source = "../modules/4iam_role"

  role_name          = var.lambda_role_name
  policy_arns        = var.lambda_policy_arns
  tags               = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy = jsonencode({
     Version: "2012-10-17",
     Statement: [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  })
}


# module "lambda_docker" {
#   source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/lambda_docker?ref=main"

#   function_name         = var.function_name
#   role_arn              = module.iam_role.iam_role_arn
#   image_uri             = var.image_uri
#   timeout               = var.timeout
#   memory_size           = var.memory_size
#   architectures         = var.architectures
#   environment_variables = var.environment_variables
#   tags                  = var.tags
# }

# module "api_gateway" {
#   source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/api_gateway?ref=main"
#   api_name          = var.api_name
#   description       = var.description
#   resource_path     = var.resource_path
#   http_method       = var.http_method
#   authorization     = var.authorization
#   lambda_invoke_arn = module.lambda_docker.lambda_invoke_arn
#   stage_name        = var.stage_name
#   region            = var.region
#   lambda_function_name = module.lambda_docker.function_name
# }