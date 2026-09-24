output "bucket_id" {
  description = "The name of the bucket."
  value       = module.s3.s3_bucket_id
}

output "bucket_arn" {
  description = "The ARN the S3 bucket created by the s3_module."
  value       = module.s3.s3_bucket_arn
}

output "bucket_name" {
  description = "The bucket domain name."
  value       = module.s3.s3_bucket_bucket_domain_name
}
