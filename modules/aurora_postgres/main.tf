resource "aws_secretsmanager_secret" "rds_secret" {}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.rds_username
    password = random_password.rds_password.result
  })

  depends_on = [aws_secretsmanager_secret.rds_secret]
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.rds_instance_identifier
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version = "15.3"
  skip_final_snapshot       = false
  master_username         = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  master_password         = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
  database_name           = var.rds_instance_db_name
  db_subnet_group_name    = aws_db_subnet_group.generic_subnet_group.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  storage_encrypted       = var.rds_instance_storage_encrypted
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg_param_group.name
  tags                    = var.rds_instance_tags
  copy_tags_to_snapshot   = true

  depends_on = [aws_secretsmanager_secret_version.rds_secret_version]
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = var.rds_instance_multi_az ? 2 : 1
  identifier         = "${var.rds_instance_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.rds_instance_class
  engine             = "aurora-postgresql"
  tags               = var.rds_instance_tags
}

resource "aws_rds_cluster_parameter_group" "aurora_pg_param_group" {
  name   = var.parameter_group_name
  family = var.parameter_group_family
  tags   = var.rds_instance_tags
}

resource "aws_db_subnet_group" "generic_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.rds_instance_tags
}