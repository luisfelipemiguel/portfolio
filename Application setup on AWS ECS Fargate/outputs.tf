output "ecs_cluster_id" {
  description = "The ECS cluster ID"
  value       = module.ecs.ecs_cluster_id
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.ecs_service_name
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = module.ecs.ecs_task_definition_arn
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = module.ecs.ecs_task_execution_role_arn
}

output "ec_tags_cluster" {
  description = "Tags assigned to the ElastiCache cluster."
  value       = local.ec_tags_cluster
}

output "ec_tags_subnet_group" {
  description = "Tags assigned to the ElastiCache subnet group."
  value       = local.ec_tags_subnet_group
}

output "elasticache_endpoint" {
  value = module.elasticache.elasticache_endpoint
}

output "elasticache_port" {
  value = module.elasticache.elasticache_port
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = var.db_name
}

output "rds_db_password" {
  description = "The password for the RDS database"
  value       = var.db_password
}

output "rds_db_username" {
  description = "The username for the RDS database"
  value       = var.db_username
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}



