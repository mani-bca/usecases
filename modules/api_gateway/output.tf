output "api_url" {
  value = "https://${aws_apigatewayv2_api.this.api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}

data "aws_region" "current" {}