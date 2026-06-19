module "ec2_instance" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/ec2_instance_module?ref=main"

  name          = var.name
  ami           = var.ami
  instance_type = var.instance_type

  inline_policy_statements = var.inline_policy_statements
}

