# Applies to objects stored in the INTELLIGENT_TIERING storage class (uploaded with that class or moved
# there by a lifecycle transition): objects not accessed for a while move to the archive tiers.
resource "aws_s3_bucket_intelligent_tiering_configuration" "bucket" {
  count = var.intelligent_tiering_enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  name   = "entire-bucket"
  status = "Enabled"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = var.intelligent_tiering_archive_days
  }

  dynamic "tiering" {
    for_each = var.intelligent_tiering_deep_archive_days > 0 ? [var.intelligent_tiering_deep_archive_days] : []
    content {
      access_tier = "DEEP_ARCHIVE_ACCESS"
      days        = tiering.value
    }
  }
}
