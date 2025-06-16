variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = ""
}

variable "endpoint_types" {
  description = "List of endpoint types (EDGE, REGIONAL, PRIVATE)"
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "path_part" {
  description = "Path part for the resource (e.g., 'hello')"
  type        = string
}

variable "http_method" {
  description = "HTTP method for the method (e.g., GET, POST)"
  type        = string
}

variable "authorization" {
  description = "Authorization type (e.g., NONE, AWS_IAM, CUSTOM)"
  type        = string
  default     = "NONE"
}

variable "integration_http_method" {
  description = "HTTP method used for the integration request"
  type        = string
  default     = "POST"
}

variable "integration_type" {
  description = "Integration type (HTTP, MOCK, AWS, AWS_PROXY)"
  type        = string
}

variable "integration_uri" {
  description = "URI of the integration endpoint (e.g., Lambda or HTTP endpoint)"
  type        = string
}

variable "stage_name" {
  description = "Deployment stage name (e.g., dev, prod)"
  type        = string
}