resource "aws_route53_zone" "rothwell-dev-zone" {
  name = "rothwell.dev"
}

resource "aws_route53_record" "rothwell-dev-ns" {
  zone_id = aws_route53_zone.rothwell-dev-zone.zone_id
  name    = "rothwell.dev"
  type    = "NS"
  ttl     = 172800

  records = [
    "ns-1389.awsdns-45.org.",
    "ns-186.awsdns-23.com.",
    "ns-1887.awsdns-43.co.uk.",
    "ns-865.awsdns-44.net.",
  ]
}

resource "aws_route53_record" "rothwell-dev-soa" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.rothwell-dev-zone.zone_id
  name            = "rothwell.dev"
  type            = "SOA"
  ttl             = 900
  records         = ["ns-865.awsdns-44.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
}

resource "aws_route53_record" "rothwell-dev-a-record" {
  zone_id = aws_route53_zone.rothwell-dev-zone.zone_id
  name    = "rothwell.dev"
  type    = "A"

  alias {
    name                   = aws_alb.playground_alb_load_balancer.dns_name
    zone_id                = aws_alb.playground_alb_load_balancer.zone_id
    evaluate_target_health = true
  }
}