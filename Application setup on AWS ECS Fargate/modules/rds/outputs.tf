output "aws_db_instance_identifier" {
  description = "Identifier of the AWS database instance"
  value       = aws_db_instance.this.identifier
}

output "db_instance_endpoint" {
  description = "Endpoint of the AWS database instance"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "Port number for the AWS database instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = var.db_name
}

output "db_password" {
  description = "Password for the database"
  value       = var.db_password
  sensitive   = true
}

output "db_username" {
  description = "Username for the database"
  value       = var.db_username
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}
