resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr_block
  tags = merge(local.tags,{ "Name" : "main-vpc" })
}

resource "aws_subnet" "front-tier-sn" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.front_tier_cidr_block
  availability_zone = "us-east-1a"
  tags = merge(local.tags,{"Name":"front-tier-sn"})
}

resource "aws_subnet" "app-tier-sn" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.app_tier_cidr_block
  availability_zone = "us-east-1b"
  tags = merge(local.tags,{"Name":"app-tier-sn"})
}

resource "aws_security_group" "front-tier-sg" {
  name   = "front-tier-sg"
  vpc_id = aws_vpc.main_vpc.id
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
  tags = {
    task = "wordpress-deploy"
    Name = "app-tier-sg"
  }
}

resource "aws_security_group_rule" "app-tier-ingress-rule" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.app-tier-sg.id
  to_port           = 80
  type              = "ingress"
  source_security_group_id = aws_security_group.front-tier-sg.id
}