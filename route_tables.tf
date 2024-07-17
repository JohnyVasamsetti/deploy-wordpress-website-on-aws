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

resource "aws_route_table" "db-tier-rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-nat-gateway.id
  }
}

# Route table to Subnet association
resource "aws_route_table_association" "front-tier-1-rta" {
  route_table_id = aws_route_table.front-tier-rt.id
  subnet_id = aws_subnet.front-tier-sn-1.id
}

resource "aws_route_table_association" "front-tier-2-rta" {
  route_table_id = aws_route_table.front-tier-rt.id
  subnet_id = aws_subnet.front-tier-sn-2.id
}

resource "aws_route_table_association" "app-tier-1-rta" {
  route_table_id = aws_route_table.app-tier-rt.id
  subnet_id = aws_subnet.app-tier-sn-1.id
}

resource "aws_route_table_association" "app-tier-2-rta" {
  route_table_id = aws_route_table.app-tier-rt.id
  subnet_id = aws_subnet.app-tier-sn-2.id
}

resource "aws_route_table_association" "db-tier-1-rta" {
  route_table_id =aws_route_table.db-tier-rt.id
  subnet_id = aws_subnet.db-tier-sn-1.id
}

resource "aws_route_table_association" "db-tier-2-rta" {
  route_table_id =aws_route_table.db-tier-rt.id
  subnet_id = aws_subnet.db-tier-sn-2.id
}