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
| <a name="module_alb"></a> [alb](#module\_alb) | ../module/alb | n/a |
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | ../module/security_group | n/a |
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | ../module/iam_role | n/a |
| <a name="module_ecs_fargate"></a> [ecs\_fargate](#module\_ecs\_fargate) | ../module/ecs_fargate | n/a |
| <a name="module_ecs_sg"></a> [ecs\_sg](#module\_ecs\_sg) | ../module/security_group | n/a |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | ../module/iam_role | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../module/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appointment_desired_count"></a> [appointment\_desired\_count](#input\_appointment\_desired\_count) | n/a | `number` | n/a | yes |
| <a name="input_appointment_health_path"></a> [appointment\_health\_path](#input\_appointment\_health\_path) | n/a | `string` | n/a | yes |
| <a name="input_appointment_image"></a> [appointment\_image](#input\_appointment\_image) | n/a | `string` | n/a | yes |
| <a name="input_appointment_path"></a> [appointment\_path](#input\_appointment\_path) | n/a | `string` | n/a | yes |
| <a name="input_appointment_port"></a> [appointment\_port](#input\_appointment\_port) | n/a | `number` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS Cluster name | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `number` | n/a | yes |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Whether to create a NAT Gateway | `bool` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | VPC name | `string` | n/a | yes |
| <a name="input_patient_desired_count"></a> [patient\_desired\_count](#input\_patient\_desired\_count) | n/a | `number` | n/a | yes |
| <a name="input_patient_health_path"></a> [patient\_health\_path](#input\_patient\_health\_path) | n/a | `string` | n/a | yes |
| <a name="input_patient_image"></a> [patient\_image](#input\_patient\_image) | n/a | `string` | n/a | yes |
| <a name="input_patient_path"></a> [patient\_path](#input\_patient\_path) | n/a | `string` | n/a | yes |
| <a name="input_patient_port"></a> [patient\_port](#input\_patient\_port) | n/a | `number` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR blocks for private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for public subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_ecs_service_ids"></a> [ecs\_service\_ids](#output\_ecs\_service\_ids) | n/a |
| <a name="output_ecs_service_names"></a> [ecs\_service\_names](#output\_ecs\_service\_names) | n/a |
| <a name="output_ecs_task_definition_arns"></a> [ecs\_task\_definition\_arns](#output\_ecs\_task\_definition\_arns) | n/a |
<!-- END_TF_DOCS -->