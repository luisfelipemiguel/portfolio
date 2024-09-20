variable "backup_retention_period" {
  description = "Backup retention period for the RDS instance (in days)."
  type        = number
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance (in GB)."
  type        = number
}

variable "db_identifier" {
  description = "Identifier for the RDS instance."
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance."
  type        = string
}

variable "db_name" {
  description = "Name of the database."
  type        = string
}

variable "db_password" {
  description = "Password for the database."
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Username for the database."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "engine" {
  description = "Database engine type."
  type        = string
}

variable "multi_az" {
  description = "Whether to create a Multi-AZ deployment."
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible."
  type        = bool
}

variable "security_groups" {
  description = "List of security group IDs for the RDS instance."
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the RDS instance."
  type        = bool
}

variable "storage_encrypted" {
  description = "Whether to enable storage encryption."
  type        = bool
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group."
  type        = list(string)
}