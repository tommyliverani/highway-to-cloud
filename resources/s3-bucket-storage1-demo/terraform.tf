terraform {
  required_version = ">= 1.10.0"

  # Backend blocks cannot use variables: bucket, region and key come from the "backend" object
  # of variables.json and are passed by the deploy pipeline with -backend-config.
  # The state lives in the platform's S3 bucket like every other resource, whatever the cloud.
  backend "s3" {
    use_lockfile = true
  }
}
