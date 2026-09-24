terraform {
  required_version = ">= 1.10.0"

  # Backend blocks cannot use variables: the values are written here when the resource is rendered.
  backend "s3" {
    bucket       = "highway-to-cloud-tfstate-311618538285"
    region       = "eu-south-1"
    key          = "resources/test--124ofrev/terraform.tfstate"
    use_lockfile = true
  }
}
