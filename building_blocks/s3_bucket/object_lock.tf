resource "aws_s3_bucket_object_lock_configuration" "bucket" {
  count = var.object_lock_enabled ? 1 : 0
  
  bucket = aws_s3_bucket.bucket.id

  rule {
    default_retention {
      mode = var.object_lock_retention_type
      days = var.object_lock_retention_days
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.bucket
  ]
}