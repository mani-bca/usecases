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

# Security Group for ALB
module "alb_sg" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/security_group?ref=main"
  
  name_prefix  = "${var.project_name}-${var.environment}"
  name         = "alb-sg"
  description  = "Security group for the ALB"
  vpc_id       = module.vpc.vpc_id
  
  ingress_with_cidr_blocks = var.alb_sg_ingress_cidr
  
  egress_rules = var.alb_sg_egress_rules
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
  depends_on = [
    module.vpc
  ]
}

# Security Group for EC2 Instances
module "ec2_sg" {
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
    module.vpc
  ]
}

# EC2 Instances
module "ec2_instances1" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=main"
  
  name_prefix               = "${var.project_name}-${var.environment}-homepage"
  subnet_id                 = module.vpc.public_subnet_ids[0]
  security_group_ids        = [module.ec2_sg.security_group_id]
  associate_public_ip_address = true
  key_name                  = var.key_name
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  user_data_script          = "${path.root}/scripts/homepage.sh"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "homepage"
  }

  depends_on = [
    module.vpc,
    module.alb_sg,
    module.ec2_sg
  ]
}

module "ec2_instances2" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=main"
  
  name_prefix               = "${var.project_name}-${var.environment}-image"
  subnet_id                 = module.vpc.public_subnet_ids[1]
  security_group_ids        = [module.ec2_sg.security_group_id]
  associate_public_ip_address = true
  key_name                  = var.key_name
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  user_data_script          = "${path.root}/scripts/image.sh"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "image"
  }

  depends_on = [
    module.vpc,
    module.alb_sg,
    module.ec2_sg
  ]
}

module "ec2_instances3" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/ec2?ref=main"
  
  name_prefix               = "${var.project_name}-${var.environment}-register"
  subnet_id                 = module.vpc.public_subnet_ids[2]
  security_group_ids        = [module.ec2_sg.security_group_id]
  associate_public_ip_address = true
  key_name                  = var.key_name
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  user_data_script          = "${path.root}/scripts/register.sh"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "register"
  }

  depends_on = [
    module.vpc,
    module.alb_sg,
    module.ec2_sg
  ]
}

# ALB and Path-Based Routing
module "alb" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/alb?ref=main"
  
  name_prefix = "${var.project_name}-${var.environment}"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]
  
  # Target Groups
  target_groups = {
    homepage = {
      port     = 80
      protocol = "HTTP"
      health_check = {
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    },
    image = {
      port     = 80
      protocol = "HTTP"
      health_check = {
        path                = "/image"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    },
    register = {
      port     = 80
      protocol = "HTTP"
      health_check = {
        path                = "/register"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    }
  }
  
  # Default target group for root path (/)
  default_target_group_key = "homepage"
  
  # Target Group Attachments
  target_group_attachments = [
    {
      target_group_key = "homepage"
      target_id        = module.ec2_instances1.instance_id
      port             = 80
    },
    {
      target_group_key = "image"
      target_id        = module.ec2_instances2.instance_id
      port             = 80
    },
    {
      target_group_key = "register"
      target_id        = module.ec2_instances3.instance_id
      port             = 80
    }
  ]
  # Path-based routing rules
  path_based_rules = {
    image = {
      priority      = 10
      path_patterns = ["/image*"]
      target_group_key = "image"
    },
    register = {
      priority      = 20
      path_patterns = ["/register*"]
      target_group_key = "register"
    }
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
  depends_on = [
    module.vpc,
    module.alb_sg,
    module.ec2_instances1,
    module.ec2_instances2,
    module.ec2_instances3
  ]

}

# Example output to demonstrate usage
output "vpc_details" {
  description = "VPC details"
  value = {
    vpc_id            = module.vpc.vpc_id
    public_subnets    = module.vpc.public_subnet_ids
    private_subnets   = module.vpc.private_subnet_ids
    nat_gateway_id    = module.vpc.nat_gateway_id
  }
}