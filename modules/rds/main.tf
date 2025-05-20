# module "securitygroups" {
#   source            = "../networking/securitygroups"
#   name              = var.sg_name
#   description       = var.sg_description
#   vpc_id            = var.sg_vpc_id
#   sg_ingress_rules  = var.sg_ingress_rules
#   tags              = var.sg_tags
# }
 
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
 
resource "aws_db_instance" "my_rds_instance" {
  identifier                = var.rds_instance_identifier
  engine                    = var.rds_instance_engine
  instance_class            = var.rds_instance_class
  allocated_storage         = var.rds_instance_allocated_storage
  db_subnet_group_name      = aws_db_subnet_group.generic_subnet_group.name
  vpc_security_group_ids    = [module.securitygroups.sg_out]
  multi_az                  = var.rds_instance_multi_az
  storage_encrypted         = var.rds_instance_storage_encrypted
  kms_key_id                = var.rds_instance_kms_key_id
  db_name                   = var.rds_instance_db_name
  parameter_group_name      = var.parameter_group_name
  tags                      = var.rds_instance_tags
  copy_tags_to_snapshot     = true
 
  username                  = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  password                  = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
 
  depends_on = [aws_db_subnet_group.generic_subnet_group, aws_secretsmanager_secret_version.rds_secret_version]
}
 
resource "aws_db_parameter_group" "generic_pg_param_group" {
  name   = var.parameter_group_name
  family = var.parameter_group_family
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