terraform {
  required_version = ">= 1.10.0"

  # Backend blocks cannot use variables: the values are written here when the resource is rendered.
  backend "s3" {
    bucket       = "highway-to-cloud-tfstate-311618538285"
    region       = "us-east-1"
    key          = "resources/highway-to-cloud-3/terraform.tfstate"
    use_lockfile = true
  }
}
