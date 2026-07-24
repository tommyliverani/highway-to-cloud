variable "bucket_name" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "enable_server_side_encryption" {
  description = "Enable server side encryption"
  type        = bool
  default     = false
}

variable "kms_key" {
  description = "KMS key"
  type        = string
}

variable "kms_sse_alg" {
  description = "Server side encryption algorithm. Valid values are: AES256 and aws:kms."
  type        = string
  default     = "AES256"
}

variable "object_lock_enabled" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = bool
  default     = false
}


variable "object_lock_retention_type" {
  description = "The type of Object Lock retention. Valid values are: GOVERNANCE or COMPLIANCE."
  type        = string
  default     = "GOVERNANCE"
}

variable "object_lock_retention_days" {
  description = "The number of days for Object Lock retention."
  type        = number
  default     = 365
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
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