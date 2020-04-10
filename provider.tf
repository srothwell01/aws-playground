provider "aws" {
  profile                 = "terraform-playground"
  shared_credentials_file = "~/.aws/credentials"
  region                  = var.region
}