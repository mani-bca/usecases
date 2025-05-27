variable "log_group_name" {
  description = "CloudWatch Logs group name"
  type        = string
}

variable "alarm_name" {
  description = "Name for the CloudWatch alarm"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to trigger alert"
  type        = string
}