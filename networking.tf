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
  subnet_id = aws_subnet.front-tier-sn-1.id
  allocation_id = aws_eip.main-eip.id
  tags = merge(local.tags,{"Name":"Nat-Gateway"})
}