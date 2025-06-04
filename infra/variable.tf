variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use (must provide 3 for this module)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnets"
  type        = bool
  default     = false
}
############SG
variable "ec2_ingress_rules" {
  type        = list(object({
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks     = optional(list(string))
  security_groups = optional(list(string))
  }))

  
}

variable "ec2_egress_rules" {
  type        = list(object({
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks     = optional(list(string))
  security_groups = optional(list(string))
  }))
  
}

variable "rds_egress_rules" {
  type        = list(object({
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks     = optional(list(string))
  security_groups = optional(list(string))
  }))
  
}
variable "rds_ingress_rules" {
  type        = list(object({
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks     = optional(list(string))
  security_groups = optional(list(string))
  }))
  
}





variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "my-vpc"
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}



