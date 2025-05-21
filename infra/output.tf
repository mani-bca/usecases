output "api_endpoint" {
  value = "${aws_api_gateway_stage.search_api.invoke_url}/search"
}

output "document_bucket" {
  value = aws_s3_bucket.document_bucket.bucket
}

output "db_connection_string" {
  value = "postgresql://${aws_db_instance.postgres.username}:${random_password.db_password.result}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
  sensitive = true
}