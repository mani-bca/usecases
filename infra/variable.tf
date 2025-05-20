variable "secret_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "secret_values" {
  type = map
  default = {
  }
}
################security group
variable "sg_name" {}

variable "sg_description" {}

variable "sg_vpc_id" {}

variable "sg_ingress_rules" {
  type        = map
}

variable "sg_tags" {
  type = map(string)
  default = {
    "terraform" = "True"
  }
}

#############RDS
variable "rds_instance_identifier" {
  type = string
}

variable "rds_instance_engine" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_instance_allocated_storage" {
  type = string
}

variable "rds_instance_subnet_group" {
  type = string
}

variable "rds_instance_multi_az" {
  type = bool
}

variable "rds_instance_storage_encrypted" {
  type = bool
}

variable "rds_instance_kms_key_id" {
  type = string
}

variable "rds_instance_db_name" {
  type = string
}

variable "rds_instance_parameter_group" {
  type = string
}
variable "rds_instance_parameter_description" {
  type = string
}

variable "rds_instance_parameter_group_family" {
  type = string
}

variable "rds_instance_tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "subnet_group_name" {}
variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map
  default = {
    "terraform" = "True"
  }
}

variable "parameter_group_name" {
  type = string
}

variable "parameter_group_family" {
  type = string
}

variable "rds_secret_id" {
  type  = string
}

variable "rds_username" {
  type        = string
  sensitive   = true
}

# variable "my_db_proxy" {
#   type  = string
# }

# variable "proxy_role_arn" {
#   type        = string
# }

# variable "secret_name" {
#   type = string
# }

# variable "secret_description" {
#   type = string
# }

# variable "secret_rc_window" {
#   type = string
# }
