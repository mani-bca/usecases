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

module "lambda_sg" {
  source        = "../modules/2sg"
  name          = "lambda-sg"
  description   = "SG for Lambda"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = []
  egress_rules  = var.lambda_egress_rules
  tags          = var.tags
  depends_on = [
    module.raw_s3_bucket,
    module.vpc
  ]

}

module "rds_sg" {
  source        = "../modules/security_group"
  name          = "rds-sg"
  description   = "SG for RDS"
  vpc_id        = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.lambda_sg.security_group_id]
    }
  ]

  egress_rules = var.rds_egress_rules
  tags         = var.tags
  depends_on = [
    module.raw_s3_bucket,
    module.vpc
  ]
}
