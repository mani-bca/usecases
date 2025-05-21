# S3 Bucket for document storage
resource "aws_s3_bucket" "document_bucket" {
  bucket = "semantic-search-docs-${random_string.suffix.result}"
  force_destroy = true
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

# Enable S3 notifications for Lambda triggers
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.document_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.document_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".pdf"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.document_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }
}

# Lambda for document processing
resource "aws_lambda_function" "document_processor" {
  function_name = "document-processor"
  runtime       = "python3.9"
  handler       = "processor.lambda_handler"
  timeout       = 300
  memory_size   = 1024
  
  filename      = "document_processor.zip"
  source_code_hash = filebase64sha256("document_processor.zip")
  
  role = aws_iam_role.lambda_role.arn
  
  environment {
    variables = {
      DB_HOST     = aws_db_instance.postgres.address
      DB_PORT     = aws_db_instance.postgres.port
      DB_NAME     = "semantic_search"
      DB_USER     = "postgres"
      DB_PASSWORD = random_password.db_password.result
    }
  }
}

# Lambda for search API
resource "aws_lambda_function" "search_api" {
  function_name = "semantic-search-api"
  runtime       = "python3.9"
  handler       = "search_api.lambda_handler"
  timeout       = 30
  memory_size   = 512
  
  filename      = "search_api.zip"
  source_code_hash = filebase64sha256("search_api.zip")
  
  role = aws_iam_role.lambda_role.arn
  
  environment {
    variables = {
      DB_HOST     = aws_db_instance.postgres.address
      DB_PORT     = aws_db_instance.postgres.port
      DB_NAME     = "semantic_search"
      DB_USER     = "postgres"
      DB_PASSWORD = random_password.db_password.result
    }
  }
}

# IAM Role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "semantic_search_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  role = aws_iam_role.lambda_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.document_bucket.arn,
          "${aws_s3_bucket.document_bucket.arn}/*"
        ]
      }
    ]
  })
}

# API Gateway for search endpoint
resource "aws_api_gateway_rest_api" "search_api" {
  name        = "semantic-search-api"
  description = "API for semantic search"
}

resource "aws_api_gateway_resource" "search" {
  rest_api_id = aws_api_gateway_rest_api.search_api.id
  parent_id   = aws_api_gateway_rest_api.search_api.root_resource_id
  path_part   = "search"
}

resource "aws_api_gateway_method" "search_post" {
  rest_api_id   = aws_api_gateway_rest_api.search_api.id
  resource_id   = aws_api_gateway_resource.search.id
  http_method   = "POST"
  authorization_type = "NONE"
}

resource "aws_api_gateway_integration" "search_lambda" {
  rest_api_id = aws_api_gateway_rest_api.search_api.id
  resource_id = aws_api_gateway_resource.search.id
  http_method = aws_api_gateway_method.search_post.http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.search_api.invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.search_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.search_api.execution_arn}/*/*"
}

# Deployment and stage
resource "aws_api_gateway_deployment" "search_api" {
  depends_on = [
    aws_api_gateway_integration.search_lambda
  ]
  
  rest_api_id = aws_api_gateway_rest_api.search_api.id
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "search_api" {
  deployment_id = aws_api_gateway_deployment.search_api.id
  rest_api_id   = aws_api_gateway_rest_api.search_api.id
  stage_name    = "prod"
}

# Generate random password for RDS
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# Create a security group for the RDS instance
resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Allow PostgreSQL traffic"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this to your VPC CIDR
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# PostgreSQL RDS instance with pgvector
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.3"  # Ensure this version supports pgvector
  instance_class       = "db.t3.micro"
  db_name              = "semantic_search"
  username             = "postgres"
  password             = random_password.db_password.result
  parameter_group_name = aws_db_parameter_group.postgres_params.name
  skip_final_snapshot  = true
  publicly_accessible  = true  # For development only
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
}

# Parameter group for RDS to enable pgvector
resource "aws_db_parameter_group" "postgres_params" {
  name   = "postgres-params"
  family = "postgres15"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,vector"
  }
}
