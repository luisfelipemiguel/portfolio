resource "aws_elasticache_cluster" "this" {
  cluster_id           = var.elasticache_cluster_id
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = var.port
  num_cache_nodes      = var.num_cache_nodes
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = var.security_group_ids

  tags = {
    Name        = "${var.ec_environment}-elasticache-cluster"
    ec_environment = var.ec_environment
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.ec_environment}-elasticache-subnet-group"
  }
}
