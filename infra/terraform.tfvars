# General settings
aws_region   = "us-east-1"
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
 region                          = "us-east-1"
rds_username                    = "auroraadmin"
rds_instance_identifier         = "aurora-pg-cluster"
rds_instance_class              = "db.r6g.large"
rds_instance_db_name            = "auroradb"
rds_instance_multi_az           = true
rds_instance_storage_encrypted  = true
parameter_group_name            = "aurora-pg-custom"
parameter_group_family          = "aurora-postgresql15"
subnet_ids                      = ["subnet-abc123", "subnet-def456"]
subnet_group_name               = "aurora-pg-subnet-group"
vpc_security_group_ids          = ["sg-abc123"]
rds_instance_tags = {
  Environment = "dev"
  Project     = "aurora-postgres"
}