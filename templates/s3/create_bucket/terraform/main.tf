module "s3" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/terraform/s3_bucket_module?ref=main"

  bucket_name           = var.bucket_name
  bucket_namespace      = var.bucket_namespace
  force_destroy         = var.force_destroy
  enable_server_side_encryption = var.enable_server_side_encryption
  kms_key               = var.kms_key
  kms_sse_alg           = var.kms_sse_alg
  object_lock_enabled   = var.object_lock_enabled
  object_lock_retention_type = var.object_lock_enabled ? var.object_lock_retention_type : null
  object_lock_retention_days = var.object_lock_enabled ? var.object_lock_retention_days : null
  tags = var.tags

  intelligent_tiering_enabled           = var.intelligent_tiering_enabled
  intelligent_tiering_archive_days      = var.intelligent_tiering_archive_days
  intelligent_tiering_deep_archive_days = var.intelligent_tiering_deep_archive_days

  lifecycle_rule_enabled                       = var.lifecycle_rule_enabled
  lifecycle_transition_days                    = var.lifecycle_transition_days
  lifecycle_transition_storage_class           = var.lifecycle_transition_storage_class
  lifecycle_expiration_days                    = var.lifecycle_expiration_days
  lifecycle_noncurrent_version_expiration_days = var.lifecycle_noncurrent_version_expiration_days
  lifecycle_abort_multipart_days               = var.lifecycle_abort_multipart_days
}

