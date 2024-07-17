resource "aws_kms_key" "storage_key" {
  description = "Key for encrypting wordpress file storage"
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = merge(local.tags,{"Name":"storage_kms"})
}

resource "aws_efs_file_system" "wordpress-file-storage" {
  creation_token = "wordpress"
  encrypted = true
  kms_key_id = aws_kms_key.storage_key.arn
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = merge(local.tags,{"Name":"wordpress-storage"})
}

resource "aws_efs_mount_target" "storage-mt-1" {
  file_system_id = aws_efs_file_system.wordpress-file-storage.id
  subnet_id      = aws_subnet.db-tier-sn-1.id
  security_groups = [aws_security_group.storage-tier-sg.id]
}

resource "aws_efs_mount_target" "storage-mt-2" {
  file_system_id = aws_efs_file_system.wordpress-file-storage.id
  subnet_id      = aws_subnet.db-tier-sn-2.id
  security_groups = [aws_security_group.storage-tier-sg.id]
}