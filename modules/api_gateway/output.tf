output "invoke_url" {
  value = "https://${aws_apigatewayv2_api.this.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}/hello"
}
