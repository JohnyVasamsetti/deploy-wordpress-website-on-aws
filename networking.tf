resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr_block
  tags = {
    task = "wordpress-deploy"
    Name = "j03-vpc"
  }
}

resource "aws_subnet" "app-tier-sn" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = local.app_tier_cidr_block
  tags = merge({"Name":"app-tier-sn"},local.tags)
}