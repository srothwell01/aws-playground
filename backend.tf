terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sroth"

    workspaces {
      name = "aws-playground"
    }
  }
}