module "ec2" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/terraform/ec2_instance_module?ref=main"

  name                   = var.name
  ami                    = var.ami
  ami_ssm_parameter      = var.ami_ssm_parameter
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  root_volume_size       = var.root_volume_size
  root_volume_encrypted  = var.root_volume_encrypted
  imds_v2_required       = var.imds_v2_required
  tags                   = var.tags

  inline_policy_statements = var.inline_policy_statements
}
