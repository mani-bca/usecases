resource "aws_servicecatalog_portfolio" "this" {
  name          = var.portfolio_name
  description   = var.portfolio_description
  provider_name = var.provider_name
}

resource "aws_servicecatalog_product" "this" {
  name  = var.product_name
  owner = var.product_owner
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name         = var.provisioning_name
    type         = "CLOUD_FORMATION_TEMPLATE"
    template_url = var.template_url
  }
}

resource "aws_servicecatalog_product_portfolio_association" "this" {
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
}

resource "aws_servicecatalog_constraint" "template_constraint" {
  count        = var.enable_template_constraint ? 1 : 0
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
  type         = "TEMPLATE"
  parameters   = jsonencode(var.template_constraint_parameters)
}

resource "aws_servicecatalog_constraint" "launch_constraint" {
  count        = var.enable_launch_constraint ? 1 : 0
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
  type         = "LAUNCH"
  parameters   = jsonencode({ RoleArn = var.launch_role_arn })
}

resource "aws_servicecatalog_tag_option" "this" {
  count = var.create_tag_option ? 1 : 0
  key   = var.tag_key
  value = var.tag_value
}

resource "aws_servicecatalog_tag_option_resource_association" "this" {
  count         = var.create_tag_option ? 1 : 0
  resource_id   = aws_servicecatalog_product.this.id
  tag_option_id = aws_servicecatalog_tag_option.this[0].id
}

resource "aws_servicecatalog_principal_portfolio_association" "this" {
  count          = var.user_arn != "" ? 1 : 0
  portfolio_id   = aws_servicecatalog_portfolio.this.id
  principal_arn  = var.user_arn
  principal_type = "IAM"
}