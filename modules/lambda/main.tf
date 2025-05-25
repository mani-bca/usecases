modules/lambda_hello_world/main.tf

data "archive_file" "lambda_zip" { type        = "zip" source_dir  = var.source_path output_path = "${path.module}/hello-world.zip" }

resource "aws_lambda_function" "this" { function_name    = var.function_name handler          = var.handler runtime          = var.runtime role             = var.role_arn filename         = data.archive_file.lambda_zip.output_path source_code_hash = data.archive_file.lambda_zip.output_base64sha256

memory_size      = var.memory_size timeout          = var.timeout layers           = var.layers environment { variables = var.environment_variables } package_type = "Zip" architectures = [var.architecture] }

modules/lambda_hello_world/variables.tf

variable "function_name" {} variable "handler" {} variable "runtime" {} variable "role_arn" {} variable "source_path" {} variable "memory_size" { default = 128 } variable "timeout" { default = 3 } variable "layers" { type = list(string), default = [] } variable "environment_variables" { type = map(string), default = {} } variable "architecture" { default = "x86_64" }

modules/lambda_hello_world/outputs.tf

output "lambda_arn" { value = aws_lambda_function.this.arn }

