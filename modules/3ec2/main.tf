resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data_script != null ? file(var.user_data_script) : null
  user_data_replace_on_change = true
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
    
    tags = merge(
      var.tags,
      {
        "Name" = "${var.ec2name}-rootebs"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.tags, { Name = var.ec2name })
}