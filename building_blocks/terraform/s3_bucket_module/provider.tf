terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37" # 6.37+: bucket_namespace (account-regional namespace)
    }
  }
  required_version = ">= 1.7.0"
}
