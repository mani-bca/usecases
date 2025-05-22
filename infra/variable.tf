variable "raw_bucket_name" { type = string }
variable "processed_bucket_name" { type = string }

variable "vpc_cidr" { type = string }
variable "subnet_ids" { type = list(string) }

variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string; sensitive = true }
variable "db_instance_class" { type = string }
variable "db_secret_name" { type = string }

variable "lambda_code_bucket" { type = string }
variable "ingest_lambda_key" { type = string }
variable "search_lambda_key" { type = string }

variable "ingest_lambda_name" { type = string }
variable "search_lambda_name" { type = string }
variable "ingest_lambda_handler" { type = string }
variable "search_lambda_handler" { type = string }

variable "lambda_runtime" { type = string }
variable "lambda_role_name" { type = string }
variable "lambda_policy_arns" { type = list(string) }

variable "api_name" { type = string }

variable "tags" { type = map(string) }