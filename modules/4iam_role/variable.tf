# variable "role_name" { 
#     type = string 
# }
# variable "policy_arns" { 
#     type = list(string) 
# }
# variable "tags" { 
#     type = map(string) 
# }
# variable "inline_policy" {
#   description = "IAM inline policy in JSON format"
#   type        = string
#   default     = null
# }

# variable "assume_role_policy" {
#   description = "The assume role policy document in JSON format. This defines who or what can assume this role."
#   type        = string
# }
##################################3below is new update
variable "role_name" {
  description = "Name of the IAM role."
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy document in JSON format. This defines who or what can assume this role."
  type        = string
}

variable "policy_arns" {
  description = "List of ARNs of managed policies to attach to the role."
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "IAM inline policy in JSON format. Set to null if no inline policy is needed."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}