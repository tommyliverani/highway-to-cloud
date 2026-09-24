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

variable "kms_key" {
  description = "KMS key"
  type        = string
}

variable "enable_server_side_encryption" {
  description = "Enable server side encryption"
  type        = bool
  default     = false
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

variable "intelligent_tiering_enabled" {
  description = "Move objects stored in the INTELLIGENT_TIERING class to the archive tiers when not accessed."
  type        = bool
  default     = false
}

variable "intelligent_tiering_archive_days" {
  description = "Days without access before objects move to the Archive Access tier (90-730)."
  type        = number
  default     = 90

  validation {
    condition     = var.intelligent_tiering_archive_days >= 90 && var.intelligent_tiering_archive_days <= 730
    error_message = "intelligent_tiering_archive_days must be between 90 and 730."
  }
}

variable "intelligent_tiering_deep_archive_days" {
  description = "Days without access before objects move to the Deep Archive Access tier (180-730, 0 = disabled)."
  type        = number
  default     = 0

  validation {
    condition     = var.intelligent_tiering_deep_archive_days == 0 || (var.intelligent_tiering_deep_archive_days >= 180 && var.intelligent_tiering_deep_archive_days <= 730)
    error_message = "intelligent_tiering_deep_archive_days must be 0 or between 180 and 730."
  }
}

variable "lifecycle_rule_enabled" {
  description = "Apply a lifecycle rule to every object of the bucket."
  type        = bool
  default     = false
}

variable "lifecycle_transition_days" {
  description = "Days after creation before objects move to lifecycle_transition_storage_class (0 = no transition)."
  type        = number
  default     = 0
}

variable "lifecycle_transition_storage_class" {
  description = "Storage class objects move to: STANDARD_IA, INTELLIGENT_TIERING, GLACIER or DEEP_ARCHIVE."
  type        = string
  default     = "STANDARD_IA"

  validation {
    condition     = contains(["STANDARD_IA", "INTELLIGENT_TIERING", "GLACIER", "DEEP_ARCHIVE"], var.lifecycle_transition_storage_class)
    error_message = "lifecycle_transition_storage_class must be STANDARD_IA, INTELLIGENT_TIERING, GLACIER or DEEP_ARCHIVE."
  }
}

variable "lifecycle_expiration_days" {
  description = "Days after creation before objects are deleted (0 = never)."
  type        = number
  default     = 0
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "Days before non-current object versions are deleted (0 = never)."
  type        = number
  default     = 0
}

variable "lifecycle_abort_multipart_days" {
  description = "Days before incomplete multipart uploads are aborted (0 = never)."
  type        = number
  default     = 7
}