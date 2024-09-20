output "elasticache_endpoint" {
  description = "The endpoint of the ElastiCache cluster."
  value       = aws_elasticache_cluster.this.cache_nodes[0].address
}

output "elasticache_port" {
  description = "The port of the ElastiCache cluster."
  value       = aws_elasticache_cluster.this.port
}

output "elasticache_url" {
  description = "The URL of the ElastiCache cluster."
  value       = "redis://${aws_elasticache_cluster.this.cache_nodes[0].address}:${aws_elasticache_cluster.this.port}"
}
