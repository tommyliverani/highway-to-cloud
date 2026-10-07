variable "name" {
  description = "Name of the instance: Name tag, and prefix of the IAM role and instance profile."
  type        = string
}

variable "ami" {
  description = "AMI ID to use for the instance. If null, ami_ssm_parameter is resolved instead."
  type        = string
  default     = null
}

variable "ami_ssm_parameter" {
  description = "Public SSM parameter holding the AMI ID, used when ami is null (follows the latest image)."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet of the instance. If null, a subnet of the default VPC."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size in GiB of the root volume."
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "EBS volume type of the root volume."
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Encrypt the root volume."
  type        = bool
  default     = true
}

variable "root_volume_kms_key_id" {
  description = "KMS key of the root volume. If null, the default EBS key of the account. Requires root_volume_encrypted."
  type        = string
  default     = null
}

variable "imds_v2_required" {
  description = "Require IMDSv2 (session tokens) to read the instance metadata."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags of the instance."
  type        = map(string)
  default     = {}
}

variable "inline_policy_statements" {
  description = "Lista di statement IAM da includere nella policy inline del ruolo EC2."
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  default = []
}
