variable "sg_tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {
    "terraform" = "True"
  }
}

variable "sg_name" {}

variable "sg_description" {}

variable "sg_vpc_id" {}

variable "sg_ingress_rules" {
  description = "Ingress security group rules"
  type        = map
}