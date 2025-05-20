# General settings
aws_region   = "us-east-1"
project_name = "usecase-11"
environment  = "dev"
##security group
sg_name           = "rds-sg-dev"
sg_description    = "security group for rds instance dev"
sg_vpc_id         = "vpc-0bd1562f11536b9dd"
sg_tags           = {
  "SG_group" = "for rds",
}
 
sg_ingress_rules = { 
  	"1" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["0.0.0.0/0"]
		description			= "HTTPS From Private Subnets Dev"
	},
	"2" = {
		from_port			= 80
		to_port				= 80
		protocol			= "tcp"
		cidr_blocks			= ["0.0.0.0/0"]
		description			= "HTTP within private subnet"
	},
	"3" = {
		from_port			= 22
		to_port				= 22
		protocol			= "tcp"
		cidr_blocks			= ["0.0.0.0/0"]
		description			= "SSH within private subnet"
	}
}
 
subnet_group_name = "rds-subnet-group-dev"
subnet_ids = [
  "subnet-0aade558b97319d86",
   "subnet-0211abeb4ee6ef699"
]
 
rds_instance_identifier       = "rds-postgres-rds-dev"
rds_instance_engine           = "postgres"
rds_instance_class            = "db.t3.medium"
rds_instance_allocated_storage= "20"
rds_instance_subnet_group     = "rds-subnet-group"
rds_instance_multi_az         = true
rds_instance_storage_encrypted= true
rds_instance_kms_key_id       = "arn:aws:kms:us-east-1:116762271881:key/feb03c78-5883-45af-b385-2a8f6af95851"
rds_instance_db_name          = "rds"
rds_instance_parameter_group  = "rds-pg-param-group"
rds_instance_tags = {
  "ApplicationName" = "rds",
  "Automated"       = "True",
}
 
parameter_group_name = "rds-pg-param-group"
parameter_group_family = "postgres16"
rds_secret_id = "rds-rds-postgres-secret-dev"
  
rds_instance_parameter_description = "Description of the parameter group"
rds_instance_parameter_group_family = "postgres16"
 
rds_username = "postgresuser"