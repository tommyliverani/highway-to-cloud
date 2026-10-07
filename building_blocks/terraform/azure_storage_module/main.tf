resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# The S3 bucket equivalent on Azure is a container inside a storage account: the account holds the settings
# (redundancy, encryption, network), the container the data. One account per container keeps them independent.
resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  access_tier              = var.access_tier

  https_traffic_only_enabled      = true
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.public_access_allowed

  blob_properties {
    versioning_enabled = var.versioning_enabled

    dynamic "delete_retention_policy" {
      for_each = var.soft_delete_retention_days > 0 ? [1] : []
      content {
        days = var.soft_delete_retention_days
      }
    }

    dynamic "container_delete_retention_policy" {
      for_each = var.soft_delete_retention_days > 0 ? [1] : []
      content {
        days = var.soft_delete_retention_days
      }
    }
  }

  dynamic "identity" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [var.customer_managed_key.user_assigned_identity_id]
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      key_vault_key_id          = var.customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Storage retention (the Azure equivalent of S3 Object Lock): blobs cannot be modified or deleted for
# retention_days after they are written.
resource "azurerm_storage_container_immutability_policy" "this" {
  count = var.retention_days > 0 ? 1 : 0

  storage_container_resource_manager_id = azurerm_storage_container.this.id
  immutability_period_in_days           = var.retention_days
  locked                                = var.retention_locked
}
