variable "aws_region"{
  type = string
}
variable "environment"{
  type = string
}

variable "secret_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "secret_values" {
  type = map
  default = {
  }
}
################security group
variable "sg_name" {}

variable "sg_description" {}

variable "sg_vpc_id" {}

variable "sg_ingress_rules" {
  type        = map
}

variable "sg_tags" {
  type = map(string)
  default = {
    "terraform" = "True"
  }
}

#############RDS
variable "rds_username" {}
variable "rds_instance_identifier" {}
variable "rds_instance_engine" {}
variable "rds_instance_class" {}
variable "rds_instance_allocated_storage" {}
variable "rds_instance_multi_az" { type = bool }
variable "rds_instance_storage_encrypted" { type = bool }
variable "rds_instance_db_name" {}
variable "parameter_group_name" {}
variable "parameter_group_family" {}
variable "subnet_ids" { type = list(string) }
variable "subnet_group_name" {}
variable "vpc_security_group_ids" { type = list(string) }
variable "rds_instance_tags" { type = map(string) }