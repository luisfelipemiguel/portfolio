output "aws_db_instance" {
  value = aws_db_instance.this
}

output "database_url" {
  value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.this.endpoint}/${var.db_name}"
}

output "db_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  value = aws_db_instance.this.port
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}