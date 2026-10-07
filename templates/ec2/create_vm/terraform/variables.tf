# Parameters (the user's request)

variable "name" {
  description = "Name of the instance: Name tag, and prefix of the IAM role and instance profile."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

# Platform

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "account_id" {
  description = "The AWS account ID."
  type        = string
}

variable "ami_ssm_parameter" {
  description = "Public SSM parameter holding the AMI ID."
  type        = string
}

variable "root_volume_size" {
  description = "Size in GiB of the root volume."
  type        = number
}

variable "root_volume_type" {
  description = "EBS volume type of the root volume."
  type        = string
}

variable "subnet_id" {
  description = "(Optional) Subnet of the instance. If null, a subnet of the default VPC."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags of the instance."
  type        = map(string)
  default     = {}
}

# Security

variable "root_volume_encrypted" {
  description = "Encrypt the root volume."
  type        = bool
}

variable "root_volume_kms_key_id" {
  description = "(Optional) KMS key of the root volume. If null, the default EBS key of the account."
  type        = string
  default     = null
}
