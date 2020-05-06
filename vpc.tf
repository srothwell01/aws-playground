# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "playground_vpc" {
  cidr_block = var.playground_network_cidr

  tags = {
    Name = "playground"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "playground_ig" {
  vpc_id = aws_vpc.playground_vpc.id
  tags = {
    Name = "playground_ig"
  }
}

# Elastic IP for the NAT gateway
resource "aws_eip" "playground_nat_gw_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.playground_ig]
}

# NAT gateway for private subnet
# Gateway must be created in a public subnet
resource "aws_nat_gateway" "playground_nat_gw" {
  allocation_id = aws_eip.playground_nat_gw_eip.id
  subnet_id     = aws_subnet.playground_public_sn_01.id

  depends_on = [aws_internet_gateway.playground_ig]
}

# Public subnet 1
resource "aws_subnet" "playground_public_sn_01" {
  vpc_id            = aws_vpc.playground_vpc.id
  cidr_block        = var.playground_public_01_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "playground_public_sn_01"
  }
}

# Public subnet 2
resource "aws_subnet" "playground_public_sn_02" {
  vpc_id            = aws_vpc.playground_vpc.id
  cidr_block        = var.playground_public_02_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "playground_public_sn_02"
  }
}

# Private subnet 1
resource "aws_subnet" "playground_private_sn_01" {
  vpc_id            = aws_vpc.playground_vpc.id
  cidr_block        = var.playground_private_01_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "playground_private_sn_01"
  }
}

# Routing table for public subnet 1
resource "aws_route_table" "playground_public_sn_rt_01" {
  vpc_id = aws_vpc.playground_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.playground_ig.id
  }
  tags = {
    Name = "playground_public_sn_rt_01"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "playground_public_sn_rt_01_assn" {
  subnet_id      = aws_subnet.playground_public_sn_01.id
  route_table_id = aws_route_table.playground_public_sn_rt_01.id
}

# Routing table for public subnet 2
resource "aws_route_table" "playground_public_sn_rt_02" {
  vpc_id = aws_vpc.playground_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.playground_ig.id
  }
  tags = {
    Name = "playground_public_sn_rt_02"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "playground_public_sn_rt_02_assn" {
  subnet_id      = aws_subnet.playground_public_sn_02.id
  route_table_id = aws_route_table.playground_public_sn_rt_02.id
}

# Routing table for private subnet 1
resource "aws_route_table" "playground_private_sn_rt_01" {
  vpc_id = aws_vpc.playground_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.playground_nat_gw.id
  }
  tags = {
    Name = "playground_private_sn_rt_01"
  }
}

# Associate the routing table to private subnet 1
resource "aws_route_table_association" "playground_private_sn_rt_assn_01" {
  subnet_id      = aws_subnet.playground_private_sn_01.id
  route_table_id = aws_route_table.playground_private_sn_rt_01.id
}

# ELB public security group
resource "aws_security_group" "playground_public_sg" {
  name        = "playground_public_sg"
  description = "Public access security group"
  vpc_id      = aws_vpc.playground_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.playground_public_01_cidr, var.playground_public_02_cidr, var.playground_private_01_cidr]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "playground_public_sg"
  }
}

# ECS Instance Security group
resource "aws_security_group" "playground_private_ecs_sg" {
  name        = "playground_private_ecs_sg"
  description = "private access security group for ECS"
  vpc_id      = aws_vpc.playground_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
    cidr_blocks = [var.playground_public_01_cidr, var.playground_public_02_cidr, var.playground_private_01_cidr]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "playground_private_ecs_sg"
  }
}

# NACLs
resource "aws_network_acl" "playground_public_nacl" {
  vpc_id = aws_vpc.playground_vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 205
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  tags = {
    Name = "main"
  }
}