resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "this" {
  name                           = "web-client"
  user_pool_id                   = aws_cognito_user_pool.this.id
  callback_urls                  = var.callback_urls
  logout_urls                    = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows           = ["code"]
  allowed_oauth_scopes          = ["email", "openid", "profile"]
  supported_identity_providers  = ["COGNITO"]
  generate_secret                = false
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}