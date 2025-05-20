output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "rds_secret_arn" {
  value = aws_secretsmanager_secret.rds_secret.arn
}