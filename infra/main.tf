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


data "aws_region" "current" {}

module "api_gateway" {
  source                  = "../modules/6apirest"
  name                    = var.name
  description             = var.description
  endpoint_types          = var.endpoint_types
  path_part               = var.path_part
  http_method             = var.http_method
  authorization           = var.authorization
  integration_http_method = var.integration_http_method
  integration_type        = var.integration_type
  integration_uri         = var.integration_uri
  stage_name              = var.stage_name
}
