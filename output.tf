output "region" {
  value = var.region
}

output "playground_vpc_id" {
  value = aws_vpc.playground_vpc.id
}

output "playground_public_sn_01_id" {
  value = aws_subnet.playground_public_sn_01.id
}

output "playground_public_sn_02_id" {
  value = aws_subnet.playground_public_sn_02.id
}

output "playground_public_sg_id" {
  value = aws_security_group.playground_public_sg.id
}

output "app-alb-load-balancer-name" {
  value = aws_alb.playground_alb_load_balancer.name
}

output "app-alb-load-balancer-dns-name" {
  value = aws_alb.playground_alb_load_balancer.dns_name
}

output "playground-app-target-group-arn" {
  value = aws_alb_target_group.playground_app_target_group.arn
}

#output "ecs-service-role-arn" {
#  value = aws_iam_role.ecs-service-role.arn
#}
#
#output "ecs-instance-role-name" {
#  value = aws_iam_role.ecs-instance-role.name
#}