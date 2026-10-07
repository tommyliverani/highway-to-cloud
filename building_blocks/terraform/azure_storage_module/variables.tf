variable "storage_account_name" {
  description = "Name of the storage account: 3-24 lowercase letters and numbers, unique across all of Azure."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters and numbers."
  }
}

variable "container_name" {
  description = "Name of the blob container (the bucket): 3-63 lowercase letters, numbers and hyphens."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group of the storage account."
  type        = string
}

variable "create_resource_group" {
  description = "Create the resource group (false: it must already exist)."
  type        = bool
  default     = false
}

variable "location" {
  description = "Azure region of the storage account."
  type        = string
}

variable "replication_type" {
  description = "Redundancy of the data: LRS, ZRS, GRS, RAGRS, GZRS or RAGZRS."
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "Default access tier of the blobs: Hot, Cool or Cold."
  type        = string
  default     = "Hot"
}

variable "versioning_enabled" {
  description = "Keep previous versions of the blobs."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Days deleted blobs and containers can be restored (0 = disabled)."
  type        = number
  default     = 7
}

variable "min_tls_version" {
  description = "Minimum TLS version accepted by the storage account."
  type        = string
  default     = "TLS1_2"
}

variable "public_access_allowed" {
  description = "Allow containers to be made publicly readable."
  type        = bool
  default     = false
}

variable "customer_managed_key" {
  description = "Encrypt with a key of Key Vault instead of a Microsoft-managed key: the key id and the user-assigned identity allowed to use it. If null, Microsoft-managed keys."
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default = null
}

variable "tags" {
  description = "Tags of the storage account."
  type        = map(string)
  default     = {}
}
