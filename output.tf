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