# General settings
aws_region   = "us-east-1"
project_name = "usecase-11"
environment  = "dev"

sg_name           = "schrute-rds-sg-dev"
sg_description    = "schrute security group for rds instance dev"
sg_vpc_id         = "vpc-00ff8e33839358d28"
sg_tags           = {
  "ApplicationName" = "Schrute",
}
 
sg_ingress_rules = { 
  	"1" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["10.153.14.0/23"]
		description			= "HTTPS From Private Subnets Dev"
	},
	"2" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["10.64.0.0/16"]
		description			= "HTTPS From Palo VPN"
	},
	"3" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["10.33.99.102/32"]
		description			= "HTTPS From Devlsys7"
	},
	"4" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["202.168.90.114/32"]
		description			= "HTTPS From Virtusa Navalur Tunnel"
	},
	"5" = {
		from_port			= 443
		to_port				= 443
		protocol			= "tcp"
		cidr_blocks			= ["203.62.174.143/32"]
		description			= "HTTPS From Virtusa Navalur Tunnel"
	}, 
	"6" = {
		from_port			= 80
		to_port				= 80
		protocol			= "tcp"
		cidr_blocks			= ["10.153.14.0/23"]
		description			= "HTTP within private subnet"
	},
	"7" = {
		from_port			= 22
		to_port				= 22
		protocol			= "tcp"
		cidr_blocks			= ["10.153.14.0/23"]
		description			= "SSH within private subnet"
	},
	"8" = {
		from_port			= 8080
		to_port				= 8080
		protocol			= "tcp"
		cidr_blocks			= ["10.153.14.0/23"]
		description			= "TomCat port within private subnet"
	}
}
 
subnet_group_name = "schrute-subnet-group-dev"
subnet_ids = [
  "subnet-06291ceaa523f684c",
   "subnet-0734d8f28467d319f"
]
 
rds_instance_identifier       = "schrute-postgres-rds-dev"
rds_instance_engine           = "postgres"
rds_instance_class            = "db.t3.medium"
rds_instance_allocated_storage= "20"
rds_instance_subnet_group     = "schrute-subnet-group"
rds_instance_multi_az         = true
rds_instance_storage_encrypted= true
rds_instance_kms_key_id       = "arn:aws:kms:us-east-1:116762271881:key/feb03c78-5883-45af-b385-2a8f6af95851"
rds_instance_db_name          = "schrute"
rds_instance_parameter_group  = "schrute-pg-param-group"
rds_instance_tags = {
  "ApplicationName" = "Schrute",
  "Automated"       = "True",
}
 
parameter_group_name = "schrute-pg-param-group"
parameter_group_family = "postgres16"
rds_secret_id = "schrute-rds-postgres-secret-dev"
  
rds_instance_parameter_description = "Description of the parameter group"
rds_instance_parameter_group_family = "postgres16"
 
rds_username = "postgresuser"