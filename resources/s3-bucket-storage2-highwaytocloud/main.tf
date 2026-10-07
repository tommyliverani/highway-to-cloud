locals {
  # Storage account names are unique across all of Azure and only allow 3-24 lowercase letters and numbers:
  # prefix + user name without hyphens, cut to 18, + 6 characters of a hash of subscription and name, so the
  # same name in two subscriptions does not collide. The user only sees the container name.
  base                 = substr(replace(lower("${var.name_prefix}${var.name}"), "/[^a-z0-9]/", ""), 0, 18)
  storage_account_name = "${local.base}${substr(sha1("${var.subscription_id}/${var.name}"), 0, 6)}"
}

module "storage" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/terraform/azure_storage_module?ref=main"

  storage_account_name = local.storage_account_name
  container_name       = var.name

  resource_group_name = var.resource_group_name
  location            = var.location

  replication_type           = var.replication_type
  access_tier                = var.access_tier
  versioning_enabled         = var.versioning_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = var.tags

  min_tls_version       = var.min_tls_version
  public_access_allowed = var.public_access_allowed
  customer_managed_key  = var.customer_managed_key
}
