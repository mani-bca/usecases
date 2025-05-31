# General settings
aws_region   = "us-east-1"
project_name = "webapp"
environment  = "dev"

tags = {
  Environment = "dev"
  Project     = "delete"
}

# VPC settings
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
create_nat_gateway   = true

# EC2 settings
web_server_ami           = "ami-0f88e80871fd81e91"
web_server_instance_type = "t2.micro"
ssh_key_name             = "devops"
admin_ip_cidr            = "0.0.0.0/0"
root_volume_type         = "gp2"
root_volume_size         = 8
iam_instance_profile     = null

# RDS settings
db_allocated_storage    = 20
db_storage_type         = "gp2"
db_engine_version       = "8.0"
db_instance_class       = "db.t3.micro"
db_name                 = "webapp_db"
db_username             = "admin"
db_password             = "ChangeMe123!"
db_parameter_group      = "default.mysql8.0"
db_multi_az             = false
db_backup_retention     = 7
db_backup_window        = "03:00-04:00"
db_maintenance_window   = "sun:05:00-sun:06:00"
db_deletion_protection  = false
db_skip_final_snapshot  = true
db_apply_immediately    = true