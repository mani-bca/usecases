# VPC Module
module "vpc" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/vpc?ref=45f8b42"
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
    

module "web_server_sg" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/sg2?ref=45f8b42"
  
  name        = "web-server"
  name_prefix = var.project_name
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id
  
  # Ingress rules - making sure all attributes are present
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"  # Make sure protocol is explicitly set for all rules
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"  # Make sure protocol is explicitly set for all rules
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"  # The error was likely here - missing protocol
      cidr_blocks = [var.admin_ip_cidr]
      description = "Allow SSH from admin IP"
    }
  ]
  
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  
  tags = var.tags
}

module "rds_sg" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/sg2?ref=45f8b42"
  
  name        = "rds"
  name_prefix = var.project_name
  description = "Security group for RDS MySQL instance"
  vpc_id      = module.vpc.vpc_id
  

  ingress_rules = []
  
  source_security_group_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"  # Make sure protocol is explicitly set
      source_security_group_id = module.web_server_sg.security_group_id
      description              = "Allow MySQL from web servers"
    }
  ]
  
  # Make sure egress rules have all required attributes
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  
  tags = var.tags
}
# EC2 Instances
module "web_server_1" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=45f8b42"
  
  name_prefix                = "${var.project_name}-web-server-1"
  ami_id                     = var.web_server_ami
  instance_type              = var.web_server_instance_type
  subnet_id                  = module.vpc.public_subnet_ids[0]
  security_group_ids         = [module.web_server_sg.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = true
  user_data_script          = "${path.root}/scripts/ecom.sh"
  
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  iam_instance_profile       = var.iam_instance_profile
  
  tags = var.tags
}

module "web_server_2" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=45f8b42"
  
  name_prefix                = "${var.project_name}-web-server-2"
  ami_id                     = var.web_server_ami
  instance_type              = var.web_server_instance_type
  subnet_id                  = module.vpc.public_subnet_ids[1]
  security_group_ids         = [module.web_server_sg.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = true
  user_data_script          = "${path.root}/scripts/ecom.sh"
  
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  iam_instance_profile       = var.iam_instance_profile
  
  tags = var.tags
}

module "rds" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/rds?ref=45f8b42"
  
  name_prefix = "${var.project_name}-mysql"
  
  # Database configuration
  engine           = "mysql"
  engine_version   = var.db_engine_version
  instance_class   = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type     = var.db_storage_type
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306
  
  # Network configuration
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.rds_sg.security_group_id]
  multi_az               = var.db_multi_az
  publicly_accessible    = false
  
  parameter_group_name   = var.db_parameter_group
  
  backup_retention_period = var.db_backup_retention
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window
  
  performance_insights_enabled = false
  performance_insights_retention_period = 7
  
  monitoring_interval = 0
  monitoring_role_arn = null
  
  deletion_protection = var.db_deletion_protection
  skip_final_snapshot = var.db_skip_final_snapshot
  
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false
  
  # Apply changes immediately
  apply_immediately = var.db_apply_immediately
  
  tags = var.tags
}

output "vpc_details" {
  description = "VPC details"
  value = {
    vpc_id            = module.vpc.vpc_id
    public_subnets    = module.vpc.public_subnet_ids
    private_subnets   = module.vpc.private_subnet_ids
    nat_gateway_id    = module.vpc.nat_gateway_id
  }
}
