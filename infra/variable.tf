variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
#######################iam
variable "lambda_role_name" {
  description = "Name of the IAM resource"
  type        = string
}

variable "lambda_policy_arns" {
  description = "List of managed policies to attach"
  type        = list(string)
}

#################api

variable "name" {
  description = "API name"
  type        = string
}

variable "description" {
  description = "API description"
  type        = string
  default     = ""
}

variable "endpoint_types" {
  type    = list(string)
  default = ["REGIONAL"]
}

variable "path_part" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorization" {
  type    = string
  default = "NONE"
}

variable "integration_http_method" {
  type    = string
  default = "POST"
}

variable "integration_type" {
  type = string
}

variable "integration_uri" {
  type = string
}

variable "stage_name" {
  type = string
}