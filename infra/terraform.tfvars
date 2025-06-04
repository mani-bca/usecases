ec2_ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

ec2_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

rds_ingress_rules = [
  {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${module.ec2_sg.this_security_group_id}"]
  }
]

rds_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

tags = {
  Environment = "dev"
  Project     = "example"
}
