terraform {
  required_version = ">= 1.10.0"

  # Backend blocks cannot use variables: bucket, region and key come from the "backend" object
  # of variables.json and are passed by the deploy pipeline with -backend-config.
  backend "s3" {
    use_lockfile = true
  }
}
