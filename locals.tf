locals {
  vpc_cidr_block = "10.0.0.0/16"
  front_tier_cidr_block = "10.0.0.0/24"
  app_tier_cidr_block= "10.0.1.0/24"
  region = "us-east-1"
  ami_id = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  tags = { "task": "wordpress-deploy" }
}