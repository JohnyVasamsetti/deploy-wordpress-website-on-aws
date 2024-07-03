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
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app-tier-sg.id
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = aws_security_group.front-tier-sg.id
}