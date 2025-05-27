provider "aws" {
  region = var.region
}

module "sns" {
  source        = "./modules/sns"
  topic_name    = "aws-login-alerts"
  email_address = var.alert_email
}

module "cloudwatch" {
  source          = "./modules/cloudwatch"
  log_group_name  = "aws-login-logs"
  alarm_name      = "console-login-alarm"
  sns_topic_arn   = module.sns.sns_topic_arn
}

module "cloudtrail" {
  source                   = "./modules/cloudtrail"
  bucket_name              = "aws-login-audit-${var.region}"
  trail_name               = "org-console-login-trail"
  cloudwatch_log_group_arn = module.cloudwatch.log_group_arn
  cloudwatch_role_arn      = module.cloudwatch.cloudwatch_role_arn
}