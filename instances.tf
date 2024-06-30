resource "aws_instance" "front-tier-instance" {
  ami = local.ami_id
  instance_type = local.instance_type
  subnet_id = aws_subnet.front-tier-sn.id
  security_groups = [ aws_security_group.front-tier-sg.id]
  key_name = aws_key_pair.instance_key.key_name
  tags = merge(local.tags,{"Name":"front-tier-instance"})
}

resource "aws_instance" "app-tier-instance" {
  ami = local.ami_id
  instance_type = local.instance_type
  subnet_id = aws_subnet.app-tier-sn.id
  security_groups = [aws_security_group.app-tier-sg.id]
  key_name = aws_key_pair.instance_key.key_name
  tags = merge(local.tags,{"Name":"app-tier-instance"})
}