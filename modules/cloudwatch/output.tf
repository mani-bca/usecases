output "log_group_arn" {
  value = aws_cloudwatch_log_group.log_group.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.log_group.name
}

output "cloudwatch_role_arn" {
  value = aws_iam_role.cloudtrail_role.arn
}