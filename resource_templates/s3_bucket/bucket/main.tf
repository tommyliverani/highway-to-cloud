module "s3" {
  source = "github.com/tommyliverani/highway-to-cloud//building_blocks/s3_bucket?ref=main"

  bucket_name           = var.bucket_name
  force_destroy         = var.force_destroy
  kms_key               = var.kms_key
  kms_sse_alg           = var.kms_sse_alg
  object_lock_enabled   = var.object_lock_enabled
  object_lock_retention_type = var.object_lock_enabled ? var.object_lock_retention_type : null
  object_lock_retention_days = var.object_lock_enabled ? var.object_lock_retention_days : null
  tags = var.tags
}

