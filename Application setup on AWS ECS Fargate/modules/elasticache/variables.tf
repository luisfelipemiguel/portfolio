variable "ec_environment" {
  description = "ec_environment name (e.g., dev, prod)."
  type        = string
}

variable "elasticache_cluster_id" {
  description = "ID for the ElastiCache cluster."
  type        = string
}

variable "engine" {
  description = "Engine type for the ElastiCache cluster."
  type        = string
}

variable "engine_version" {
  description = "Version of the ElastiCache engine."
  type        = string
}

variable "node_type" {
  description = "Node type for the ElastiCache cluster."
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes in the cluster."
  type        = number
}

variable "port" {
  description = "Port for the ElastiCache cluster."
  type        = number
}

variable "security_group_ids" {
  description = "List of security group IDs for the ElastiCache cluster."
  type        = list(string)
}

variable "subnet_group_name" {
  description = "Name of the ElastiCache subnet group."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache subnet group."
  type        = list(string)
}