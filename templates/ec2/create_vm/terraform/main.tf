module "ec2" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/terraform/ec2_instance_module?ref=main"

  name          = var.name
  instance_type = var.instance_type

  ami_ssm_parameter = var.ami_ssm_parameter
  subnet_id         = var.subnet_id
  tags              = var.tags

  root_volume_size       = var.root_volume_size
  root_volume_type       = var.root_volume_type
  root_volume_encrypted  = var.root_volume_encrypted
  root_volume_kms_key_id = var.root_volume_kms_key_id
}
