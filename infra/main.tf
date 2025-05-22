module "raw_s3_bucket" {
  source      = "../modules/s3"
  bucket_name = var.raw_bucket_name
  tags        = var.tags
}

module "vpc" {
  source                = "../modules/vpc"
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
  source      = "./modules/security_group"
  name        = "lambda-sg"
  description = "SG for Lambda"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = []
  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  tags = var.tags
}

module "rds_sg" {
  source      = "./modules/security_group"
  name        = "rds-sg"
  description = "SG for RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [{
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.lambda_sg.security_group_id]
  }]
  egress_rules = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  tags = var.tags
}

module "rds_postgres" {
  source            = "../modules/rds_postgresql"
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_security_group_ids = module.rds_sg.securtiy_group_id
  tags              = var.tags
}

module "db_secret" {
  source      = "../modules/secrets_manager"
  secret_name = var.db_secret_name
  secret_value = jsonencode({
    username = var.db_username
    password = var.db_password
  })
  tags = var.tags
}

module "lambda_iam_role" {
  source         = "../modules/iam_role"
  role_name      = var.lambda_role_name
  policy_arns    = var.lambda_policy_arns
  tags           = var.tags
}

module "lambda_ingest" {
  source          = "../modules/lambda"
  function_name   = var.ingest_lambda_name
  s3_bucket       = var.lambda_code_bucket
  s3_key          = var.ingest_lambda_key
  handler         = var.ingest_lambda_handler
  runtime         = var.lambda_runtime
  role_arn        = module.lambda_iam_role.iam_role_arn
  environment_vars = {
    DB_SECRET_NAME = var.db_secret_name
    RAW_BUCKET     = var.raw_bucket_name
  }
  vpc_config = {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = module.lambda_sg.securtiy_group_id
  }
  tags = var.tags
}

module "lambda_search" {
  source          = "../modules/lambda"
  function_name   = var.search_lambda_name
  s3_bucket       = var.lambda_code_bucket
  s3_key          = var.search_lambda_key
  handler         = var.search_lambda_handler
  runtime         = var.lambda_runtime
  role_arn        = module.lambda_iam_role.iam_role_arn
  environment_vars = {
    DB_SECRET_NAME = var.db_secret_name
  }
  vpc_config = {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = module.lambda_sg.securtiy_group_id
  }
  tags = var.tags
}

module "search_api" {
  source              = "../modules/api_gateway"
  api_name            = var.api_name
  lambda_function_arn = module.lambda_search.lambda_arn
  tags                = var.tags
}
