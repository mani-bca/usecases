variable "api_name" {}
variable "stage_name" {}
variable "region" {}

variable "routes" {
  type = map(object({
    lambda_arn = string
  }))
  description = "Map of route key to Lambda ARN. E.g. { \"GET /hello\": { lambda_arn = \"arn:...\" } }"
}