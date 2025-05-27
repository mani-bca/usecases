resource "aws_s3_bucket" "trail_bucket" {
  bucket = var.bucket_name
}

resource "aws_cloudtrail" "trail" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = var.cloudwatch_log_group_arn
  cloud_watch_logs_role_arn     = var.cloudwatch_role_arn
  enable_logging                = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}