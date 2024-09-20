variable "access_logs_bucket" {
  description = "S3 bucket for access logs."
  type        = string
}

variable "access_logs_enabled" {
  description = "Whether access logs are enabled."
  type        = bool
}

variable "alb_name" {
  description = "Name of the load balancer."
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate for the HTTPS listener."
  type        = string
}

variable "connection_logs_bucket" {
  description = "S3 bucket for connection logs."
  type        = string
}

variable "connection_logs_enabled" {
  description = "Whether connection logs are enabled."
  type        = bool
}

variable "desync_mitigation_mode" {
  description = "Desync mitigation mode for the load balancer."
  type        = string
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid header fields."
  type        = bool
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing."
  type        = bool
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection."
  type        = bool
}

variable "enable_http2" {
  description = "Enable HTTP2."
  type        = bool
}

variable "evaluate_target_health" {
  description = "Whether to evaluate target health."
  type        = bool
}

variable "health_check_enabled" {
  description = "Whether health check is enabled."
  type        = bool
}

variable "health_check_interval" {
  description = "Interval for the health check."
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold for the health check."
  type        = number
}

variable "health_check_matcher" {
  description = "Matcher for the health check."
  type        = string
}

variable "health_check_path" {
  description = "Path for the health check."
  type        = string
}

variable "health_check_timeout" {
  description = "Timeout for the health check."
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for the health check."
  type        = number
}

variable "hosted_zone_id" {
  description = "ID of the hosted zone."
  type        = string
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

variable "http_redirect_port" {
  description = "Port to redirect to for HTTP listener."
  type        = string
}

variable "http_redirect_protocol" {
  description = "Protocol to redirect to for HTTP listener."
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

variable "idle_timeout" {
  description = "Idle timeout in seconds."
  type        = number
}

variable "internal" {
  description = "Whether the load balancer is internal."
  type        = bool
}

variable "ip_address_type" {
  description = "IP address type."
  type        = string
}

variable "load_balancer_type" {
  description = "Type of load balancer."
  type        = string
}

variable "preserve_host_header" {
  description = "Preserve the host header."
  type        = bool
}

variable "security_groups" {
  description = "Security groups for the load balancer."
  type        = list(string)
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener."
  type        = string
}

variable "stickiness_cookie_duration" {
  description = "Duration of stickiness cookie in seconds."
  type        = number
}

variable "stickiness_type" {
  description = "Type of stickiness."
  type        = string
}

variable "subnets" {
  description = "Subnets for the load balancer."
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group."
  type        = string
}

variable "target_group_port" {
  description = "Port of the target group."
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol of the target group."
  type        = string
}

variable "target_type" {
  description = "Target type for the target group."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the load balancer will be deployed."
  type        = string
}

variable "xff_header_processing_mode" {
  description = "XFF header processing mode."
  type        = string
}

variable "zone_name" {
  description = "Name of the record (subdomain)."
  type        = string
}