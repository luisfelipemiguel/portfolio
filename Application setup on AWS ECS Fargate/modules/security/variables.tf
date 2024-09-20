variable "elasticache_port" {
  description = "The port for ElastiCache traffic"
  type        = number
}

variable "fargate_port" {
  description = "The port for ALB to Fargate communication"
  type        = number
}

variable "http_port" {
  description = "The port for HTTP traffic"
  type        = number
}

variable "https_port" {
  description = "The port for HTTPS traffic"
  type        = number
}

variable "rds_port" {
  description = "The port for RDS traffic"
  type        = number
}

variable "security_groups" {
  description = "List of security group IDs where the rules will be applied"
  type        = list(string)
}