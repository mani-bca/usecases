<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | git::https://github.com/mani-bca/set-aws-infra.git//modules/api_gateway | main |
| <a name="module_iam_role"></a> [iam\_role](#module\_iam\_role) | git::https://github.com/mani-bca/set-aws-infra.git//modules/iam_entity | main |
| <a name="module_lambda_docker"></a> [lambda\_docker](#module\_lambda\_docker) | git::https://github.com/mani-bca/set-aws-infra.git//modules/lambda_docker | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | n/a | `string` | n/a | yes |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | n/a | `list(string)` | <pre>[<br/>  "x86_64"<br/>]</pre> | no |
| <a name="input_authorization"></a> [authorization](#input\_authorization) | n/a | `string` | n/a | yes |
| <a name="input_aws_managed_policy_arns"></a> [aws\_managed\_policy\_arns](#input\_aws\_managed\_policy\_arns) | List of managed policies to attach | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | n/a | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | ############lambda#### | `string` | n/a | yes |
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | n/a | `string` | n/a | yes |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | n/a | `string` | n/a | yes |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | n/a | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM resource | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| <a name="input_resource_path"></a> [resource\_path](#input\_resource\_path) | n/a | `string` | n/a | yes |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `number` | `10` | no |
| <a name="input_type"></a> [type](#input\_type) | IAM type: role, user, or group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_url"></a> [api\_gateway\_url](#output\_api\_gateway\_url) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
<!-- END_TF_DOCS -->