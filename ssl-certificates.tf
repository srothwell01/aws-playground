resource "aws_acm_certificate" "rothwell-dev-wildcard-cert" {
  domain_name               = "rothwell.dev"
  subject_alternative_names = ["*.rothwell.dev"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.rothwell-dev-zone.zone_id
  records = [aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.1.resource_record_type
  zone_id = aws_route53_zone.rothwell-dev-zone.zone_id
  records = [aws_acm_certificate.rothwell-dev-wildcard-cert.domain_validation_options.1.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "rothwell-dev-wildcard-cert-validation" {
  certificate_arn         = aws_acm_certificate.rothwell-dev-wildcard-cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn, aws_route53_record.cert_validation_alt1.fqdn]
}