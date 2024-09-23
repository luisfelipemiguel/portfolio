# Generic Variables

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to apply rules to."
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for network configuration."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
}


# ALB Module Variables

variable "access_logs_bucket" {
  description = "S3 bucket for access logs."
  type        = string
}

variable "access_logs_enabled" {
  description = "Whether access logs are enabled for the ALB."
  type        = bool
}

variable "alb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the ALB."
  type        = string
}

variable "connection_logs_bucket" {
  description = "S3 bucket for connection logs."
  type        = string
}

variable "connection_logs_enabled" {
  description = "Whether connection logs are enabled for the ALB."
  type        = bool
}

variable "desync_mitigation_mode" {
  description = "ALB desync mitigation mode."
  type        = string
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid header fields for the ALB."
  type        = bool
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for the ALB."
  type        = bool
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB."
  type        = bool
}

variable "enable_http2" {
  description = "Enable HTTP/2 for the ALB."
  type        = bool
}

variable "evaluate_target_health" {
  description = "Whether to evaluate target health for the listener."
  type        = bool
  default = true
}

variable "health_check_enabled" {
  description = "Whether health checks are enabled for the target group."
  type        = bool
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold for health checks."
  type        = number
}

variable "health_check_interval" {
  description = "Interval (in seconds) for health checks."
  type        = number
}

variable "health_check_matcher" {
  description = "Matcher for health checks."
  type        = string
}

variable "health_check_path" {
  description = "Path for health checks."
  type        = string
}

variable "health_check_timeout" {
  description = "Timeout (in seconds) for health checks."
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for health checks."
  type        = number
}

variable "http_default_action_type" {
  description = "Default action type for the HTTP listener."
  type        = string
}

variable "http_listener_port" {
  description = "Port for the HTTP listener."
  type        = number
}

variable "http_listener_protocol" {
  description = "Protocol for the HTTP listener."
  type        = string
}

variable "http_port" {
  description = "Port for HTTP traffic."
  type        = number
}

variable "http_redirect_port" {
  description = "Redirect port for HTTP listener."
  type        = number
}

variable "http_redirect_protocol" {
  description = "Redirect protocol for HTTP listener."
  type        = string
}

variable "http_redirect_status_code" {
  description = "Redirect status code for HTTP listener."
  type        = string
}

variable "https_default_action_type" {
  description = "Default action type for the HTTPS listener."
  type        = string
}

variable "https_listener_port" {
  description = "Port for the HTTPS listener."
  type        = number
}

variable "https_listener_protocol" {
  description = "Protocol for the HTTPS listener."
  type        = string
}

variable "https_port" {
  description = "Port for HTTPS traffic."
  type        = number
}

variable "hosted_zone_id" {
  description = "Hosted Zone ID for Route 53."
  type        = string
}

variable "idle_timeout" {
  description = "Idle timeout (in seconds) for the ALB."
  type        = number
}

variable "internal" {
  description = "Whether the ALB is internal or internet-facing."
  type        = bool
}

variable "ip_address_type" {
  description = "IP address type for the ALB (ipv4 or dualstack)."
  type        = string
}

variable "load_balancer_type" {
  description = "Type of the load balancer (application or network)."
  type        = string
}

variable "preserve_host_header" {
  description = "Whether to preserve the host header."
  type        = bool
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener."
  type        = string
}

variable "stickiness_cookie_duration" {
  description = "Cookie duration (in seconds) for stickiness."
  type        = number
}

variable "stickiness_type" {
  description = "Type of stickiness for the target group."
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group."
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group."
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group."
  type        = string
}

variable "target_type" {
  description = "Target type for the target group (instance or ip)."
  type        = string
}

variable "xff_header_processing_mode" {
  description = "X-Forwarded-For header processing mode."
  type        = string
}

variable "zone_name" {
  description = "The name of the zone."
  type        = string
}


# ECS Module Variables

variable "assign_public_ip" {
  description = "Assign public IP to resources"
  type        = bool
}

variable "container_name" {
  description = "Name of the container in the ECS task."
  type        = string
}

variable "desired_count" {
  description = "Desired count of resources"
  type        = number
}

variable "docker_image" {
  description = "Docker image URL for the ECS container."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "ecs_container_cpu" {
  description = "CPU units for the ECS container."
  type        = number
}

variable "ecs_container_memory" {
  description = "Memory (in MiB) for the ECS container."
  type        = number
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task."
  type        = number
}

variable "ecs_task_memory" {
  description = "Memory (in MiB) for the ECS task."
  type        = number
}

variable "ecs_task_storage" {
  description = "Ephemeral storage (in GiB) for the ECS task."
  type        = number
}

variable "environment" {
  description = "Environment variables for the ECS task"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "force_https" {
  description = "Flag to force HTTPS"
  type        = bool
}

variable "iam_role_managed_policy_arns" {
  description = "List of managed policy ARNs for the IAM role"
  type        = list(string)
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "launch_type" {
  description = "The launch type for the ECS service."
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name."
  type        = string
}

variable "log_group_retention" {
  description = "Log group retention period"
  type        = number
}

variable "log_stream_prefix" {
  description = "Prefix for log stream"
  type        = string
}

variable "network_mode" {
  description = "The network mode to use for the ECS task."
  type        = string
}

variable "secret_key" {
  description = "Secret key for the application."
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service."
  type        = string
}

variable "slack_app_id" {
  description = "Slack app ID."
  type        = string
}

variable "slack_client_id" {
  description = "Slack client ID."
  type        = string
}

variable "slack_client_secret" {
  description = "Slack client secret."
  type        = string
}

variable "slack_message_actions" {
  description = "Enable or disable Slack Message Actions"
  type        = bool
}

variable "slack_verification_token" {
  description = "Slack verification token."
  type        = string
}

variable "task_definition_compatibilities" {
  description = "Task definition compatibilities (EC2, Fargate)"
  type        = list(string)
}

variable "task_definition_family" {
  description = "Family name for the ECS task definition."
  type        = string
}

variable "url" {
  description = "Application URL."
  type        = string
}

variable "utils_secret" {
  description = "Utilities secret for the application."
  type        = string
}


# ElastiCache Module Variables

variable "ec_environment" {
  description = "Environment name (e.g., production, dev)."
  type        = string
}

variable "elasticache_cluster_id" {
  description = "ID of the ElastiCache cluster."
  type        = string
}

variable "engine_ec" {
  description = "Engine EC variable"
  type        = string
}

variable "engine_version" {
  description = "ElastiCache engine version."
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type."
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
}

variable "port" {
  description = "Port for ElastiCache."
  type        = number
}

variable "subnet_group_name" {
  description = "Name of the ElastiCache subnet group."
  type        = string
}


# RDS Module Variables

variable "backup_retention_period" {
  description = "Backup retention period for the RDS database."
  type        = number
}

variable "db_allocated_storage" {
  description = "Allocated storage (in GB) for the RDS database."
  type        = number
}

variable "db_identifier" {
  description = "Identifier for the RDS instance."
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the RDS database."
  type        = string
}

variable "db_name" {
  description = "Name of the RDS database."
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database."
  type        = string
}

variable "db_username" {
  description = "Username for the RDS database."
  type        = string
}

variable "engine_db" {
  description = "Database engine type."
  type        = string
}

variable "multi_az" {
  description = "Whether the RDS instance is multi-AZ."
  type        = bool
}

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible."
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deleting the RDS instance."
  type        = bool
}

variable "storage_encrypted" {
  description = "Whether the RDS storage is encrypted."
  type        = bool
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS."
  type        = list(string)
}


# Security Module Variables

variable "elasticache_port" {
  description = "Port for ElastiCache."
  type        = number
}

variable "fargate_port" {
  description = "Port for Fargate tasks."
  type        = number
}

variable "rds_port" {
  description = "Port for RDS."
  type        = number
}
