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

# Security Group for EC2 Instances
module "web_server_sg" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/security_group?ref=main"
  
  name_prefix  = "${var.project_name}-${var.environment}"
  name         = "ec2-sg"
  description  = "Security group for EC2 instances"
  vpc_id       = module.vpc.vpc_id
  
  ingress_with_source_security_group_id = [
    {
      from_port               = 80
      to_port                 = 80
      protocol                = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
      description             = "Allow HTTP from ALB"
    },
    {
      from_port               = 8000
      to_port                 = 8000
      protocol                = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
      description             = "Allow HTTP from ALB dev"
    }
  ]
  
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_allowed_cidrs
      description = "Allow SSH from specified CIDRs"
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
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
  depends_on = [
    module.vpc,
    module.alb_sg
  ]
}


module "web_server_1" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=main"
  
  name_prefix                = "${var.project_name}-web-server-1"
  ami_id                     = var.web_server_ami
  instance_type              = var.web_server_instance_type
  subnet_id                  = module.vpc.public_subnet_ids[0]
  security_group_ids         = [module.web_server_sg.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = true
  user_data_script          = "${path.root}/scripts/shell.sh"
  
  root_volume_type           = var.root_volume_type
  root_volume_size           = var.root_volume_size
  iam_instance_profile       = var.iam_instance_profile
  
  tags = var.tags
  depends_on = [
    module.vpc,
    module.alb_sg,
    module.web_server_sg
  ]
}

