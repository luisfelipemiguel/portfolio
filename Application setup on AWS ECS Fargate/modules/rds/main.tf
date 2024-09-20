resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

resource "aws_db_instance" "this" {
  identifier             = var.db_identifier
  engine                 = var.engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_groups

  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = var.storage_encrypted

  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = "${var.db_identifier}-final-snapshot"

  tags = {
    Name = var.db_name
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}
