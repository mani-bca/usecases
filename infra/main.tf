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
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/sg2?ref=45f8b42"
  
  name        = "web-server"
  name_prefix = var.project_name
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp" 
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"  
      cidr_blocks = ["0.0.0.0/0"]
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
    module.web_server_sg
  ]
}

