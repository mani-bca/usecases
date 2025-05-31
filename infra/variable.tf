variable "name" {
  description = "Name of the IAM resource"
  type        = string
}

variable "type" {
  description = "IAM type: role, user, or group"
  type        = string
}

variable "aws_managed_policy_arns" {
  description = "List of managed policies to attach"
  type        = list(string)
}

#############lambda####
variable "function_name" {
  type = string
}

#variable "role_arn" {
#  type = string
#}

variable "image_uri" {
  type = string
}

variable "timeout" {
  type = number
  default = 10
}

variable "memory_size" {
  type = number
  default = 128
}

variable "architectures" {
  type = list(string)
  default = ["x86_64"]
}

variable "environment_variables" {
  type = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}
#################api_gateway

#variable "region" {
#  type        = string
#  description = "AWS region"
#}

variable "api_name" {
  type = string
}

variable "description" {
  type = string
}

variable "resource_path" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorization" {
  type = string
}

#variable "lambda_invoke_arn" {
#  type = string
#}

variable "stage_name" {
  type = string
}
##############ecr
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

#variable "repository_name" {
#  description = "Name of the ECR repository"
#  type        = string
#}

#variable "image_tag_mutability" {
#  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
#  type        = string
#  default     = "MUTABLE"
  
#  validation {
#    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
#    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
#  }
#}

#variable "scan_on_push" {
#  description = "Indicates whether images are scanned after being pushed to the repository"
#  type        = bool
#  default     = true
#}

#variable "tags" {
#  description = "A map of tags to assign to the resource"
#  type        = map(string)
#  default     = {}
#}