provider "azurerm" {
  features {}

  # The credentials (ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID) come from the deploy environment.
  subscription_id = var.subscription_id

  # The deploy identity only has rights on the resource group: it cannot register resource providers on the
  # subscription, so Microsoft.Storage is registered once by hand (az provider register).
  resource_provider_registrations = "none"
}
