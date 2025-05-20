
resource "aws_secretsmanager_secret" "rds_secret" {
 
}
 
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.rds_username
    password = random_password.rds_password.result
  })
 
  depends_on = [aws_secretsmanager_secret.rds_secret]
}
 
resource "random_password" "rds_password" {
  length  = 16
  special = true
}
 
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.rds_instance_identifier
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  master_username         = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  master_password         = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
  database_name           = var.rds_instance_db_name
  db_subnet_group_name    = aws_db_subnet_group.generic_subnet_group.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  storage_encrypted       = var.rds_instance_storage_encrypted
  # kms_key_id            = var.rds_instance_kms_key_id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg_param_group.name
  tags                    = var.rds_instance_tags
  copy_tags_to_snapshot   = true

  depends_on = [aws_secretsmanager_secret_version.rds_secret_version]
}

# NEW RESOURCE: Aurora Cluster Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = var.rds_instance_multi_az ? 2 : 1
  identifier         = "${var.rds_instance_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.rds_instance_class
  engine             = "aurora-postgresql"
  tags               = var.rds_instance_tags
}

# CHANGED: Aurora parameter group resource
resource "aws_rds_cluster_parameter_group" "aurora_pg_param_group" {
  name   = var.parameter_group_name
  family = var.parameter_group_family # Example: aurora-postgresql15
  tags   = var.rds_instance_tags
}

resource "aws_db_subnet_group" "generic_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.rds_instance_tags
}

 
# resource "aws_db_proxy" "my_db_proxy" {
#   name                     = var.my_db_proxy
#   engine_family            = "POSTGRESQL"
#   # role_arn                 = var.proxy_role_arn
#   vpc_security_group_ids   = [module.securitygroups.sg_out]
#   vpc_subnet_ids           = var.subnet_ids
#   auth {
#     secret_arn = aws_secretsmanager_secret.rds_secret.arn
#     iam_auth   = "DISABLED"
#   }
#   idle_client_timeout       = 1800  
#   require_tls               = true  
#   debug_logging             = true  
#   tags                      = var.rds_instance_tags
# }
 
# resource "aws_db_proxy_target" "my_rds_proxy_target" {
#   db_proxy_name        = aws_db_proxy.my_db_proxy.name
#   target_group_name    = "default"
#   db_instance_identifier = aws_db_instance.my_rds_instance.identifier
 
#   depends_on = [aws_db_instance.my_rds_instance, aws_db_proxy.my_db_proxy]
# }