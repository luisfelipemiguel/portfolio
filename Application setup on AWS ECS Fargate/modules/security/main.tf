resource "aws_security_group_rule" "allow_http_alb" {
  security_group_id = var.security_groups[0]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP traffic to the ALB"
}

resource "aws_security_group_rule" "allow_https_alb" {
  security_group_id = var.security_groups[0]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTPS traffic to the ALB"
}

resource "aws_security_group_rule" "allow_elasticache_fargate" {
  security_group_id = var.security_groups[0]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.elasticache_port
  to_port           = var.elasticache_port
  source_security_group_id = var.security_groups[0]
  description       = "Allow Fargate container to connect to elasticache"
}

resource "aws_security_group_rule" "allow_alb_fargate" {
  security_group_id = var.security_groups[0]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.fargate_port
  to_port           = var.fargate_port
  source_security_group_id = var.security_groups[0]
  description       = "Allow ALB to connect to Fargate container"
}

resource "aws_security_group_rule" "allow_rds_fargate" {
  security_group_id = var.security_groups[0]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.rds_port
  to_port           = var.rds_port
  source_security_group_id = var.security_groups[0]
  description       = "Allow Fargate container to connect to PostgreSQL"
}
