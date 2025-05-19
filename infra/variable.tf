variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

# VPC Variables

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
}

# EC2 Variables

variable "web_server_ami" {
  description = "AMI ID for web servers"
  type        = string
}

variable "web_server_instance_type" {
  description = "Instance type for web servers"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of SSH key pair to use for EC2 instances"
  type        = string
}

# variable "admin_ip_cidr" {
#   description = "CIDR block for admin IP (for SSH access)"
#   type        = string
# }

variable "root_volume_type" {
  description = "Volume type for the root block device"
  type        = string
}

variable "root_volume_size" {
  description = "Volume size for the root block device in GB"
  type        = number
}

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to the instance"
  type        = string
}
# variable for sg
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
variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH to instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}