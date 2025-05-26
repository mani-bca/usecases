variable "function_name" {
  type    = string
}
variable "handler" {
  type    = string
}
variable "runtime" {
  type    = string
}
variable "source_path" {
  type    = string
}
variable "memory_size" {
  type    = number
  default = 128
}
variable "timeout" {
  type    = number
  default = 3
}
variable "layers" {
  type    = list(string)
  default = []
}
variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "architecture" {
  type    = string
  default = "x86_64"
}


# Variables for module "lambda_iam_role"
variable "lambda_role_name" {
  description = "Name for the IAM role used by the Lambda function."
  type        = string
}

variable "lambda_policy_arns" {
  description = "List of ARNs of managed policies to attach to the Lambda IAM role."
  type        = list(string)
}

# Variables for module "api_gateway"
variable "region" {
  description = "AWS region where the API Gateway will be deployed."
  type        = string
  default     = "us-east-1"
}


variable "user_pool_name" {
  description = "Name for the Cognito User Pool."
  type        = string
}

variable "domain_prefix" {
  description = "Domain prefix for the Cognito User Pool hosted UI."
  type        = string
}

# variable "callback_urls" {
#   description = "List of callback URLs for the Cognito User Pool app client."
#   type        = list(string)
# }

variable "logout_urls" {
  description = "List of logout URLs for the Cognito User Pool app client."
  type        = list(string)
  default = []
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    Project     = "HelloApp"
    Environment = "Development"
  }
}