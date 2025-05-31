aws_region   = "us-east-1"
environment  = "dev"
project_name = "NSH"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
# Availability Zones - Must provide exactly 3
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]
# Public Subnet CIDRs - should be 3
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]
# Private Subnet CIDRs - should be 3
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]
# Set to true if you need private subnets to have internet access
create_nat_gateway = false

# sg for ALB
alb_sg_ingress_cidr = [
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
  }
]

alb_sg_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
]

# ec2 Instance Configuration
instance_type = "t2.micro"
key_name = "devops"
ami_id        = "ami-0f88e80871fd81e91"
ssh_allowed_cidrs = ["0.0.0.0/0"]


