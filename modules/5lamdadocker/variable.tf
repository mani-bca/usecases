variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for Lambda execution"
  type        = string
}

variable "image_uri" {
  description = "ECR Image URI for Docker-based Lambda"
  type        = string
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Memory in MB"
  type        = number
  default     = 128
}

variable "architectures" {
  description = "Instruction set architecture"
  type        = list(string)
  default     = ["x86_64"]
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}