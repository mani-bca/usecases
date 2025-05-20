variable "rds_username" {}
variable "rds_instance_identifier" {}
variable "rds_instance_class" {}
variable "rds_instance_db_name" {}
variable "rds_instance_multi_az" { type = bool }
variable "rds_instance_storage_encrypted" { type = bool }
variable "parameter_group_name" {}
variable "parameter_group_family" {}
variable "subnet_ids" { type = list(string) }
variable "subnet_group_name" {}
variable "vpc_security_group_ids" { type = list(string) }
variable "rds_instance_tags" { type = map(string) }