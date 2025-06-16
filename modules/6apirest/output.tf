output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "rest_api_root_resource_id" {
  value = aws_api_gateway_rest_api.this.root_resource_id
}

output "invoke_url" {
  value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}

data "aws_region" "current" {}