vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = []
create_nat_gateway   = false
########################SECURITY group
ec2_ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

ec2_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

# rds_ingress_rules = [
#   {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = ["${module.ec2_sg.this_security_group_id}"]
#   }
# ]

rds_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
########################EC2 
web1name =  "web1"
web2name =  "web2"
server_ami = "ami-084568db4383264d4"
server_instance_type = "t2.micro"
ssh_key_name = "devops"
root_volume_type = "gp3"
root_volume_size = "8"


tags = {
  Environment = "dev"
  Project     = "test"
}
