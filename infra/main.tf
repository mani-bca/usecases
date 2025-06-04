module "vpc" {
  source                = "../modules/1vpc"
  name                 = "${var.name}-vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway   = var.create_nat_gateway
  
  tags = {
    Name = var.name
  }
}

module "first_sg" {
  source        = "../modules/2sg"
  name          = "lambda-sg"
  description   = "SG for Lambda"
  vpc_id        = module.vpc.vpc_id
  # ingress_rules = []
  ingress_rules = var.ec2_ingress_rules
  egress_rules  = var.ec2_egress_rules
  tags          = var.tags
}

module "second_sg" {
  source        = "../modules/2sg"
  name          = "rds-sg"
  description   = "SG for RDS"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = var.rds_ingress_rules
  egress_rules  = var.rds_egress_rules
  tags         = var.tags
}
