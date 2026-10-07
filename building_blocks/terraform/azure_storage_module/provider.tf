terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9" # 4.9+: containers addressed by storage_account_id (resource manager API, no access keys)
    }
  }
  required_version = ">= 1.7.0"
}
