# ENV/dev/outputs.tf

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.alb_sg.security_group_id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = module.ec2_sg.security_group_id
}

# EC2 Instance Outputs
output "instance_ids" {
  description = "IDs of all EC2 instances"
  value = {
    homepage = module.ec2_instances1.instance_id
    image    = module.ec2_instances2.instance_id
    register = module.ec2_instances3.instance_id
  }
}

output "instance_private_ips" {
  description = "Private IPs of all EC2 instances"
  value = {
    homepage = module.ec2_instances1.instance_private_ip
    image    = module.ec2_instances2.instance_private_ip
    register = module.ec2_instances3.instance_private_ip
  }
}

output "instance_public_ips" {
  description = "Public IPs of all EC2 instances"
  value = {
    homepage = module.ec2_instances1.instance_public_ip
    image    = module.ec2_instances2.instance_public_ip
    register = module.ec2_instances3.instance_public_ip
  }
}
# ALB Outputs
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the ALB"
  value       = module.alb.alb_zone_id
}

output "target_group_arns" {
  description = "Map of target group names to ARNs"
  value       = module.alb.target_group_arns
}