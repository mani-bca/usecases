variable "region" {
  description = "AWS region"
  type        = string
}

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
variable "name" {
  description = "VPC name"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

#variable "task_family" {
#  description = "Task definition family"
#  type        = string
#}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
}

variable "memory" {
  description = "Memory for the task"
  type        = number
}

#variable "execution_role_arn" {
#  description = "Execution role ARN"
#  type        = string
#}

#variable "task_role_arn" {
#  description = "Task role ARN"
#  type        = string
#}

#variable "container_name" {
#  description = "Container name"
#  type        = string
#}

#variable "container_image" {
#  description = "Container image"
#  type        = string
#}

#variable "container_port" {
#  description = "Container port"
#  type        = number
#}

# variable "subnet_ids" {
#   description = "List of subnet IDs for ECS services"
#   type        = list(string)
# }

#variable "services" {
#  description = "List of ECS services"
#  type = list(object({
#    name             = string
#    desired_count    = number
#    security_groups  = list(string)
#    assign_public_ip = bool
#    load_balancer = optional(object({
#      target_group_arn = string
#    }))
#  }))
#}
# variable "vpc_id" {
#   description = "VPC ID for ECS and security groups"
#   type        = string
# }

#variable "lb_target_group_arn_1" {
#  description = "Target group ARN for service1"
#  type        = string
#}

#variable "lb_target_group_arn_2" {
#  description = "Target group ARN for service1"
#  type        = string
#}

variable "appointment_port" { 
  type = number 
}
variable "appointment_path" { 
  type = string 
}
variable "appointment_health_path" { 
  type = string 
}
variable "appointment_desired_count" { 
  type = number 
}
variable "appointment_image" { 
  type = string 
}

variable "patient_port" { 
  type = number 
}
variable "patient_path" { 
  type = string 
}
variable "patient_health_path" { 
  type = string 
}
variable "patient_desired_count" { 
  type = number 
}
variable "patient_image" { 
  type = string 
}