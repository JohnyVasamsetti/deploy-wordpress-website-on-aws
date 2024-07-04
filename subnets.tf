# Subnets
resource "aws_subnet" "front-tier-sn-1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.front_tier_cidr_block_1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"front-tier-sn-1"})
}
resource "aws_subnet" "front-tier-sn-2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.front_tier_cidr_block_2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"front-tier-sn-2"})
}

resource "aws_subnet" "app-tier-sn-1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.app_tier_cidr_block_1
  availability_zone = "us-east-1a"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"app-tier-sn-1"})
}

resource "aws_subnet" "app-tier-sn-2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.app_tier_cidr_block_2
  availability_zone = "us-east-1b"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"app-tier-sn-2"})
}

resource "aws_subnet" "db-tier-sn-1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.db_tier_cidr_block_1
  availability_zone = "us-east-1a"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"db-tier-sn-1"})
}

resource "aws_subnet" "db-tier-sn-2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.db_tier_cidr_block_2
  availability_zone = "us-east-1b"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.tags,{"Name":"db-tier-sn-2"})
}