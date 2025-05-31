################################
# General Variables
################################
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

################################
# VPC Variables
################################
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

################################
# EC2 Variables
################################
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

variable "admin_ip_cidr" {
  description = "CIDR block for admin IP (for SSH access)"
  type        = string
}

variable "root_volume_type" {
  description = "Volume type for the root block device"
  type        = string
}

variable "root_volume_size" {
  description = "Volume size for the root block device in GB"
  type        = number
}

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to the instance (optional)"
  type        = string
}

################################
# RDS Variables
################################
variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance (in GB)"
  type        = number
}

variable "db_storage_type" {
  description = "Storage type for RDS instance"
  type        = string
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_parameter_group" {
  description = "Parameter group for RDS instance"
  type        = string
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
}

variable "db_backup_retention" {
  description = "Number of days to retain backups"
  type        = number
}

variable "db_backup_window" {
  description = "Preferred backup window"
  type        = string
}

variable "db_maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
}

variable "db_deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the instance is deleted"
  type        = bool
}

variable "db_apply_immediately" {
  description = "Whether to apply changes immediately or during the next maintenance window"
  type        = bool
}