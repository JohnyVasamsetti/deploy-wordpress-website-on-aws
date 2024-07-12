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
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [local.front_tier_cidr_block_1,local.front_tier_cidr_block_2]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.front_tier_cidr_block_1,local.front_tier_cidr_block_2]
  }
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

resource "aws_security_group" "db-tier-sg" {
  name = "db-tier-sg"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [local.app_tier_cidr_block_1,local.app_tier_cidr_block_2]
  }
  tags = merge(local.tags,{"Name":"db-tier-sg"})
}
resource "aws_security_group" "storage-tier-sg" {
  name = "storage-tier-sg"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}