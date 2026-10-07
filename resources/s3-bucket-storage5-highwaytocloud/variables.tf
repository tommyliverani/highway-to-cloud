# Parameters (the user's request)

variable "name" {
  description = "Name of the container (the bucket), as the user sees it."
  type        = string
}

# Platform

variable "subscription_id" {
  description = "Azure subscription."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group of the storage accounts."
  type        = string
}

variable "name_prefix" {
  description = "Prefix of the storage account names (lowercase letters and numbers)."
  type        = string
}

variable "replication_type" {
  description = "Redundancy of the data: LRS, ZRS, GRS, RAGRS, GZRS or RAGZRS."
  type        = string
}

variable "access_tier" {
  description = "Default access tier of the blobs: Hot, Cool or Cold."
  type        = string
}

variable "versioning_enabled" {
  description = "Keep previous versions of the blobs."
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "Days deleted blobs and containers can be restored (0 = disabled)."
  type        = number
}

variable "tags" {
  description = "Tags of the storage account."
  type        = map(string)
  default     = {}
}

# Security

variable "min_tls_version" {
  description = "Minimum TLS version accepted."
  type        = string
}

variable "public_access_allowed" {
  description = "Allow containers to be made publicly readable."
  type        = bool
}

variable "customer_managed_key" {
  description = "(Optional) Key Vault key and user-assigned identity to encrypt with. If null, Microsoft-managed keys."
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default = null
}
