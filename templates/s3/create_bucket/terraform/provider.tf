provider "aws" {
  region = var.region

  # The deploy credentials belong to the target account: fail if they point to a different one.
  allowed_account_ids = var.account_id != "" ? [var.account_id] : null

  default_tags {
    tags = {
      Owner = "Imola Informatica"
    }
  }
}