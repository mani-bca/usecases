resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description
  endpoint_configuration {
    types = var.endpoint_types
  }
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = var.authorization
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = var.integration_http_method
  type                    = var.integration_type
  uri                     = var.integration_uri
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.this.id

}
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.deployment.id # Links to the deployment
  rest_api_id   = aws_api_gateway_rest_api.this.id          # Links to the REST API
  stage_name    = var.stage_name                            # Uses the stage name from your input variable
}