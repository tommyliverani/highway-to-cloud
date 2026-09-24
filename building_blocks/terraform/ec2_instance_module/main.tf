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

resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name

  tags = {
    Name = var.name
  }
}