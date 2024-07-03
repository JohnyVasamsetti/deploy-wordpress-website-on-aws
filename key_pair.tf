# key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "instance_key" {
  key_name   = "instance_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
resource "aws_secretsmanager_secret" "key_pair_secret" {
  name = "ec2_key_pair"
}
resource "aws_secretsmanager_secret_version" "instance_key_version" {
  secret_string = tls_private_key.ssh_key.private_key_pem
  secret_id     = aws_secretsmanager_secret.key_pair_secret.id
}