variable "assign_public_ip" {
  description = "Whether to assign a public IP to the ECS service."
  type        = bool
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "container_name" {
  description = "Name of the container in the ECS task."
  type        = string
}

variable "desired_count" {
  description = "Desired count of ECS tasks."
  type        = number
}

variable "docker_image" {
  description = "Docker image for the ECS task."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "ecs_container_cpu" {
  description = "CPU for the ECS container."
  type        = number
}

variable "ecs_container_memory" {
  description = "Memory for the ECS container."
  type        = number
}

variable "ecs_task_cpu" {
  description = "CPU for the ECS task."
  type        = number
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task."
  type        = number
}

variable "ecs_task_storage" {
  description = "Ephemeral storage for the ECS task."
  type        = number
}

variable "environment" {
  description = "Environment variables for the ECS task"
  type        = list(object({
    name  = string
    value = string
  }))
}

variable "fargate_port" {
  description = "Port for the Fargate container."
  type        = number
}

variable "iam_role_managed_policy_arns" {
  description = "List of managed policy ARNs for the IAM role."
  type        = list(string)
}

variable "iam_role_name" {
  description = "Name of the IAM role for ECS task execution."
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name."
  type        = string
}

variable "log_group_retention" {
  description = "Retention period in days for the CloudWatch log group."
  type        = number
}

variable "log_stream_prefix" {
  description = "Log stream prefix for CloudWatch logs."
  type        = string
}

variable "security_groups" {
  description = "List of security groups for the ECS service."
  type        = list(string)
}

variable "service_name" {
  description = "Name of the ECS service."
  type        = string
}

variable "subnets" {
  description = "List of subnets for the ECS service."
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target group ARN for the load balancer."
  type        = string
}

variable "task_definition_compatibilities" {
  description = "List of compatibility types for the ECS task definition."
  type        = list(string)
}

variable "task_definition_family" {
  description = "Family name for the ECS task definition."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}