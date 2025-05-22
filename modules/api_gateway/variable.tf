variable "api_name" { type = string }
variable "stage_name" { type = string; default = "$default" }
variable "lambda_function_arn" { type = string }
variable "tags" { type = map(string) }