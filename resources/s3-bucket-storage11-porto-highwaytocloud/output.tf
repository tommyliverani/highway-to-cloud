output "storage_account_name" {
  description = "Name of the storage account that holds the container."
  value       = module.storage.storage_account_name
}

output "container_id" {
  description = "Resource ID of the container."
  value       = module.storage.container_id
}

output "container_url" {
  description = "URL of the container."
  value       = module.storage.container_url
}
