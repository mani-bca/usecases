variable "portfolio_name" {}
variable "portfolio_description" {}
variable "provider_name" {}

variable "product_name" {}
variable "product_owner" {}
variable "template_url" {}
variable "provisioning_name" {}

variable "enable_template_constraint" {
  type    = bool
  default = false
}
variable "template_constraint_parameters" {
  type    = map(any)
  default = {}
}

variable "enable_launch_constraint" {
  type    = bool
  default = false
}
variable "launch_role_arn" {
  type    = string
  default = ""
}

variable "create_tag_option" {
  type    = bool
  default = false
}
variable "tag_key" {
  type    = string
  default = "env"
}
variable "tag_value" {
  type    = string
  default = "dev"
}

variable "user_arn" {
  type    = string
  default = ""
}