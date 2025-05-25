data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.routes

  api_id                  = aws_apigatewayv2_api.this.id
  integration_type        = "AWS_PROXY"
  integration_uri         = each.value.lambda_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_lambda_permission" "apigw_invoke" {
  for_each = var.routes

  statement_id  = "AllowInvokeByAPIGateway-${replace(replace(each.key, " ", "_"), "/", "-")}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.this.id}/*/*"
}