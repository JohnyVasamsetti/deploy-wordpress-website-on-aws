locals {
  vpc_cidr_block = "10.0.0.0/16"
  app_tier_cidr_block= "10.0.0.0/24"
  region = "us-east-1"
  tags = { "task": "wordpress-deploy" }
}