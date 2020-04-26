resource "aws_acm_certificate" "rothwell-dev-wildcard-cert" {
  domain_name               = "rothwell.dev"
  subject_alternative_names = ["*.rothwell.dev"]
  validation_method         = "DNS"
  tags = {
    name = "rothwell.dev wildcard certificate"
  }
}