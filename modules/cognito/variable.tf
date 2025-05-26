variable "user_pool_name" {
  description = "Name of the Cognito user pool"
  type        = string
}

variable "domain_prefix" {
  description = "Prefix for Cognito hosted domain"
  type        = string
}

variable "callback_urls" {
  description = "List of callback URLs after login"
  type        = list(string)
}

variable "logout_urls" {
  description = "List of logout URLs"
  type        = list(string)
}