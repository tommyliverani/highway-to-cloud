resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count = var.lifecycle_rule_enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "platform-lifecycle"
    status = "Enabled"

    filter {}

    dynamic "transition" {
      for_each = var.lifecycle_transition_days > 0 ? [var.lifecycle_transition_days] : []
      content {
        days          = transition.value
        storage_class = var.lifecycle_transition_storage_class
      }
    }

    dynamic "expiration" {
      for_each = var.lifecycle_expiration_days > 0 ? [var.lifecycle_expiration_days] : []
      content {
        days = expiration.value
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.lifecycle_noncurrent_version_expiration_days > 0 ? [var.lifecycle_noncurrent_version_expiration_days] : []
      content {
        noncurrent_days = noncurrent_version_expiration.value
      }
    }

    dynamic "abort_incomplete_multipart_upload" {
      for_each = var.lifecycle_abort_multipart_days > 0 ? [var.lifecycle_abort_multipart_days] : []
      content {
        days_after_initiation = abort_incomplete_multipart_upload.value
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.lifecycle_transition_days == 0 || var.lifecycle_transition_storage_class != "STANDARD_IA" || var.lifecycle_transition_days >= 30
      error_message = "Objects can move to STANDARD_IA only after at least 30 days."
    }
    precondition {
      condition     = var.lifecycle_expiration_days == 0 || var.lifecycle_transition_days == 0 || var.lifecycle_expiration_days > var.lifecycle_transition_days
      error_message = "lifecycle_expiration_days must be greater than lifecycle_transition_days."
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.bucket
  ]
}
