resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr_block
  tags = merge(local.tags,{ "Name" : "main-vpc" })
}

resource "aws_internet_gateway" "main-ig" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(local.tags,{"Name":"Internet-Gateway"})
}

resource "aws_eip" "main-eip" {
  domain = "vpc"
  tags = merge(local.tags,{"Name":"main-eip"})
}

resource "aws_nat_gateway" "main-nat-gateway" {
  subnet_id = aws_subnet.front-tier-sn.id
  allocation_id = aws_eip.main-eip.id
  tags = merge(local.tags,{"Name":"Nat-Gateway"})
}

# Subnets
resource "aws_subnet" "front-tier-sn" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.front_tier_cidr_block
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"front-tier-sn"})
}

resource "aws_subnet" "app-tier-sn" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.app_tier_cidr_block
  availability_zone = "us-east-1a"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"app-tier-sn"})
}

# Route Tables
resource "aws_route_table" "front-tier-rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-ig.id
  }
}

resource "aws_route_table" "app-tier-rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-nat-gateway.id
  }
}

# Route table to Subnet association
resource "aws_route_table_association" "front-tier-rta" {
  route_table_id = aws_route_table.front-tier-rt.id
  subnet_id = aws_subnet.front-tier-sn.id
}

resource "aws_route_table_association" "app-tier-rta" {
  route_table_id = aws_route_table.app-tier-rt.id
  subnet_id = aws_subnet.app-tier-sn.id
}

# Security Groups
resource "aws_security_group" "front-tier-sg" {
  name   = "front-tier-sg"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    task = "wordpress-deploy"
    Name = "front-tier-sg"
  }
}

resource "aws_security_group" "app-tier-sg" {
  name = "app-tier-sg"
  vpc_id = aws_vpc.main_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    task = "wordpress-deploy"
    Name = "app-tier-sg"
  }
}

resource "aws_security_group_rule" "app-tier-ingress-rule-1" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.app-tier-sg.id
  to_port           = 80
  type              = "ingress"
  source_security_group_id = aws_security_group.front-tier-sg.id
}

resource "aws_security_group_rule" "app-tier-ingress-rule-2" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.app-tier-sg.id
  to_port           = 22
  type              = "ingress"
  source_security_group_id = aws_security_group.front-tier-sg.id
}