resource "aws_security_group" "security_group" {

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_vpc_id
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port   		= ingress.value.from_port
      to_port     		= ingress.value.to_port
      protocol    		= ingress.value.protocol
      cidr_blocks 		= ingress.value.cidr_blocks
	  // Uncomment the following to run tfvars with ipv6 blocks
      // ipv6_cidr_blocks	= ingress.value.ipv6_cidr_blocks
      description 		= ingress.value.description
    }
  }

  tags = sg_tags
}