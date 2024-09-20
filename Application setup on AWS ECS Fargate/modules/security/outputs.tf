output "allow_http_alb_id" {
  description = "The ID of the security group rule allowing HTTP traffic to the ALB"
  value       = aws_security_group_rule.allow_http_alb.id
}

output "allow_https_alb_id" {
  description = "The ID of the security group rule allowing HTTPS traffic to the ALB"
  value       = aws_security_group_rule.allow_https_alb.id
}

output "allow_alb_fargate_id" {
  description = "The ID of the security group rule allowing ALB to connect to Fargate container"
  value       = aws_security_group_rule.allow_alb_fargate.id
}
output "allow_elasticache_fargate_id" {
  description = "The ID of the security group rule allowing Fargate container to connect to elasticache"
  value       = aws_security_group_rule.allow_elasticache_fargate.id
}

output "allow_rds_fargate_id" {
  description = "The ID of the security group rule allowing Fargate container to connect to PostgreSQL"
  value       = aws_security_group_rule.allow_rds_fargate.id
}

