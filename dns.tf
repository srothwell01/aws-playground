resource "aws_route53_record" "rothwell-dev-a-record" {
  zone_id = "Z05992453GOAXPKF78Y68"
  name    = "rothwell.dev"
  type    = "A"

  alias {
    name                   = aws_alb.playground_alb_load_balancer.dns_name
    zone_id                = aws_alb.playground_alb_load_balancer.zone_id
    evaluate_target_health = true
  }
}