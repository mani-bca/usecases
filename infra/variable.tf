variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "source_path" {}
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
variable "lambda_role_name" {}
variable "lambda_policy_arns" {
  type = list(string)
}