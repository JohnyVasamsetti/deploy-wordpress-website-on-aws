resource "aws_db_instance" "rds-db" {
  instance_class = "db.t3.micro"
  storage_type = "gp2"
  allocated_storage = 20
  engine_version = "8.0"
  engine = "mysql"

  db_subnet_group_name = aws_db_subnet_group.rds-db-sng.name
  vpc_security_group_ids = [aws_security_group.db-tier-sg.id]
  multi_az = true
  kms_key_id = aws_kms_key.db_key.arn
  storage_encrypted = true

  identifier = local.rds_name
  db_name = local.rds_db_name
  username = local.rds_user_name
  password = random_password.master-password.result

  apply_immediately = true
  tags = merge(local.tags,{"Name":"${local.rds_db_name}"})
}

resource "aws_db_subnet_group" "rds-db-sng" {
  subnet_ids = [aws_subnet.db-tier-sn-1.id, aws_subnet.db-tier-sn-2.id]
}

resource "aws_kms_key" "db_key" {
  description = "Key for the rds db"
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = merge(local.tags,{"Name":"rds_kms"})
}

resource "random_password" "master-password" {
  length = 10
  special = false
}

resource "aws_secretsmanager_secret" "rds-master-creds" {
  name = "rds-master"
  kms_key_id = aws_kms_key.db_key.arn
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "rds-master-secret" {
  secret_id     = aws_secretsmanager_secret.rds-master-creds.id
  secret_string = <<EOF
  {
    "host": "${substr(aws_db_instance.rds-db.endpoint, 0, length(aws_db_instance.rds-db.endpoint) - length(":${aws_db_instance.rds-db.port}"))}",
    "port": "${aws_db_instance.rds-db.port}",
    "username": "${local.rds_user_name}",
    "password": "${random_password.master-password.result}",
    "dbname": "${local.rds_db_name}"
  }
  EOF
}
