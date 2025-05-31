variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myproject"
}

# variable "owner" {
#   description = "Owner of the resources"
#   type        = string
#   default     = "DevOps"
# }

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use (must provide 3 for this module)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  validation {
    condition     = length(var.availability_zones) == 3
    error_message = "You must provide exactly 3 availability zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  
  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "You must provide exactly 3 CIDR blocks for public subnets."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "You must provide exactly 3 CIDR blocks for private subnets."
  }
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnets"
  type        = bool
  default     = false
}

#######################################33
# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH to instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# # Certificates (optional for HTTPS)
# variable "certificate_arn" {
#   description = "ARN of the SSL certificate for HTTPS listener"
#   type        = string
#   default     = null
# }
# security group ec2 and alb variables
# variable "ec2_sg_ingress_sg" {
#   description = "Ingress rules with source SG for EC2"
#   type = list(object({
#     from_port                = number
#     to_port                  = number
#     protocol                 = string
#     source_security_group_id = string
#     description              = string
#   }))
#   default = []
# }

# variable "ec2_sg_ingress_cidr" {
#   description = "Ingress rules with CIDRs for EC2"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

# variable "ec2_sg_egress_rules" {
#   description = "Egress rules for EC2"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

variable "alb_sg_ingress_cidr" {
  description = "Ingress rules for ALB"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "alb_sg_egress_rules" {
  description = "Egress rules for ALB"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}