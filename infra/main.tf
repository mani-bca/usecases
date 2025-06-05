module "vpc" {
  source               = "../modules/1vpc"
  # name                 = "${var.name}-vpc"
  vpcname              = var.vpcname
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway   = var.create_nat_gateway
  tags                 = var.tags
}

module "first_sg" {
  source        = "../modules/2sg"
  name          = "lambda-sg"
  description   = "SG for Lambda"
  vpc_id        = module.vpc.vpc_id
  # ingress_rules = []
  ingress_rules = var.ec2_ingress_rules
  egress_rules  = var.ec2_egress_rules
  tags          = var.tags
}

module "second_sg" {
  source        = "../modules/2sg"
  name          = "rds-sg"
  description   = "SG for RDS"
  vpc_id        = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.first_sg.security_group_id]
    }
  ]
  egress_rules  = var.rds_egress_rules
  tags         = var.tags
}

module "first_ec2" {
  source = "../modules/3ec2"
  ec2name                    = var.web1name
  ami_id                     = var.server_ami
  instance_type              = var.server_instance_type
  subnet_id                  = module.vpc.public_subnet_ids[1]
  security_group_ids         = [module.first_sg.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = true
  user_data_script          = "${path.root}/scripts/userdata.sh"
  
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  
  tags = var.tags
}

module "second_ec2" {
  source = "../modules/3ec2"
  ec2name                    = var.web2name
  ami_id                     = var.server_ami
  instance_type              = var.server_instance_type
  subnet_id                  = module.vpc.public_subnet_ids[0]
  security_group_ids         = [module.first_sg.security_group_id, module.first_sg.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = true
  # user_data_script          = "${path.root}/scripts/userdata.sh"
  
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  
  tags = var.tags
}
