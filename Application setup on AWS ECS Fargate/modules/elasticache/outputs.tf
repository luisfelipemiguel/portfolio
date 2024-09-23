output "elasticache_endpoint" {
  description = "The endpoint of the ElastiCache cluster."
  value       = aws_elasticache_cluster.this.cache_nodes[0].address
}

output "elasticache_port" {
  description = "The port of the ElastiCache cluster."
  value       = aws_elasticache_cluster.this.port
}
