locals {
  vpc_cidr_block          = "10.0.0.0/16"
  front_tier_cidr_block_1 = "10.0.0.0/24"
  front_tier_cidr_block_2 = "10.0.1.0/24"
  app_tier_cidr_block_1   = "10.0.2.0/24"
  app_tier_cidr_block_2   = "10.0.3.0/24"
  db_tier_cidr_block_1    = "10.0.4.0/24"
  db_tier_cidr_block_2    = "10.0.5.0/24"

  region = "us-east-1"
  ami_id = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"

  rds_name = "wordpress-app"
  rds_db_name = "wordpress"
  rds_user_name = "dev"

  tags = { "task": "wordpress-deploy" }
}