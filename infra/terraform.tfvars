region            = "us-east-1"
# vpc_id            = "vpc-0bd1562f11536b9dd"
# subnet_ids        = ["subnet-0aade558b97319d86", "subnet-0211abeb4ee6ef699"]
tags = {
  Name = "dev"
}
name = "demo"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.6.0/24", "10.0.7.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
create_nat_gateway   = false


cluster_name      = "demo-ecs-cluster"
cpu               = 256
memory            = 512

appointment_port         = 3001
appointment_path         = "/appointments*"
appointment_health_path  = "/appointments"
appointment_desired_count = 1
appointment_image        = "676206899900.dkr.ecr.us-east-1.amazonaws.com/dev/lambda:app2"

patient_port         = 3000
patient_path         = "/patients*"
patient_health_path  = "/patients"
patient_desired_count = 1
patient_image        = "676206899900.dkr.ecr.us-east-1.amazonaws.com/dev/lambda:pat1"
