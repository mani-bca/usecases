module "sg_rds" {
  source            = "../modules/sg"
  sg_name           = var.sg_name
  sg_description    = var.sg_description
  sg_vpc_id         = var.sg_vpc_id
  sg_ingress_rules  = var.sg_ingress_rules
  sg_tags           = var.sg_tags
}

module "aurora_postgres" {
  source                        = "./modules/aurora_postgres"
  rds_username                  = var.rds_username
  rds_instance_identifier       = var.rds_instance_identifier
  rds_instance_class            = var.rds_instance_class
  rds_instance_db_name          = var.rds_instance_db_name
  rds_instance_multi_az         = var.rds_instance_multi_az
  rds_instance_storage_encrypted = var.rds_instance_storage_encrypted
  parameter_group_name          = var.parameter_group_name
  parameter_group_family        = var.parameter_group_family
  subnet_ids                    = var.subnet_ids
  subnet_group_name             = var.subnet_group_name
  vpc_security_group_ids        = var.vpc_security_group_ids
  rds_instance_tags             = var.rds_instance_tags
}