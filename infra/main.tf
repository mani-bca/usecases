# VPC Module
module "vpc" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/vpc?ref=main"
  name                 = "${var.project_name}-${var.environment}"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway   = var.create_nat_gateway
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "rds_instance" {
  source                        = "../../../modules/rds/"
  sg_name                       = var.sg_name
  sg_description                = var.sg_description
  sg_vpc_id                     = var.sg_vpc_id
  sg_ingress_rules              = var.sg_ingress_rules
  sg_tags                       = var.sg_tags
  rds_instance_identifier       = var.rds_instance_identifier
  rds_instance_engine           = var.rds_instance_engine
  rds_instance_class            = var.rds_instance_class
  rds_instance_allocated_storage= var.rds_instance_allocated_storage
  rds_instance_subnet_group     = var.rds_instance_subnet_group
  rds_instance_multi_az         = var.rds_instance_multi_az
  rds_instance_storage_encrypted= var.rds_instance_storage_encrypted
  rds_instance_kms_key_id       = var.rds_instance_kms_key_id
  rds_instance_db_name          = var.rds_instance_db_name
  rds_instance_tags             = var.rds_instance_tags
  subnet_group_name             = var.subnet_group_name
  subnet_ids                    = var.subnet_ids
  parameter_group_name          = var.parameter_group_name
  parameter_group_family        = var.parameter_group_family
  rds_secret_id                 = var.rds_secret_id
  rds_instance_parameter_group_family = var.rds_instance_parameter_group_family
  rds_instance_parameter_description = var.rds_instance_parameter_description
  rds_username                  = var.rds_username
  # my_db_proxy                 = var.my_db_proxy
  # proxy_role_arn              = var.proxy_role_arn
}