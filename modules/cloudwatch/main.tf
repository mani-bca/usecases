resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

resource "aws_iam_role" "cloudtrail_role" {
  name = "CloudTrailCloudWatchLogsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "AllowCloudTrailToWriteToCloudWatch"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_metric_filter" "login_filter" {
  name           = "ConsoleLoginMetricFilter"
  log_group_name = aws_cloudwatch_log_group.log_group.name
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.responseElements.ConsoleLogin = \"Success\") }"

  metric_transformation {
    name      = "ConsoleLoginCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "login_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsoleLoginCount"
  namespace           = "CloudTrailMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggers on successful AWS Console Logins"
  alarm_actions       = [var.sns_topic_arn]
}