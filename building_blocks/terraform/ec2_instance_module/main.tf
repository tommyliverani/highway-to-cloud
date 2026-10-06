resource "aws_iam_role" "this" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "this" {
  count = length(var.inline_policy_statements) > 0 ? 1 : 0

  name = "${var.name}-inline-policy"
  role = aws_iam_role.this.name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.inline_policy_statements
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-profile"
  role = aws_iam_role.this.name
}

data "aws_ssm_parameter" "ami" {
  count = var.ami == null ? 1 : 0

  name = var.ami_ssm_parameter
}

resource "aws_instance" "this" {
  # The value of a public parameter is an AMI ID, not a secret.
  ami                    = var.ami != null ? var.ami : nonsensitive(data.aws_ssm_parameter.ami[0].value)
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.this.name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : null

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.root_volume_encrypted
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.imds_v2_required ? "required" : "optional"
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}
