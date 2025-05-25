data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  role             = var.role_arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  memory_size = var.memory_size
  timeout     = var.timeout
  layers      = var.layers

  environment {
    variables = var.environment_variables
  }

  package_type  = "Zip"
  architectures = [var.architecture]
}