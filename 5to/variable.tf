variable "lambda_role_name" {
  description = "Name of the IAM resource"
  type        = string
}

variable "lambda_policy_arns" {
  description = "List of managed policies to attach"
  type        = list(string)
}
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
