variable "name" {
  description = "Name of the instance: Name tag, and prefix of the IAM role and instance profile."
  type        = string
}

variable "ami" {
  description = "(Optional) AMI ID. If null, ami_ssm_parameter is resolved."
  type        = string
  default     = null
}

variable "ami_ssm_parameter" {
  description = "Public SSM parameter holding the AMI ID, used when ami is null."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "(Optional) Subnet of the instance. If null, a subnet of the default VPC."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "(Optional) Security groups of the instance. If empty, the default one of the VPC."
  type        = list(string)
  default     = []
}

variable "root_volume_size" {
  description = "Size in GiB of the root volume."
  type        = number
  default     = 8
}

variable "root_volume_encrypted" {
  description = "Encrypt the root volume."
  type        = bool
  default     = true
}

variable "imds_v2_required" {
  description = "Require IMDSv2 to read the instance metadata."
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) Additional tags of the instance."
  type        = map(string)
  default     = {}
}

variable "inline_policy_statements" {
  description = "IAM statements of the inline policy of the instance role."
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  default = []
}

variable "account_id" {
  description = "(Optional) The AWS account ID."
  type        = string
  default     = ""
}

variable "region" {
  description = "(Optional) The AWS region."
  type        = string
  default     = "us-east-1"
}
