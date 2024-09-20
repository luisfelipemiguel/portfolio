resource "aws_lb" "this" {
  desync_mitigation_mode               = var.desync_mitigation_mode
  drop_invalid_header_fields           = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing     = var.enable_cross_zone_load_balancing
  enable_deletion_protection           = var.enable_deletion_protection
  enable_http2                         = var.enable_http2
  idle_timeout                         = var.idle_timeout
  internal                             = var.internal
  ip_address_type                      = var.ip_address_type
  load_balancer_type                   = var.load_balancer_type
  name                                 = var.alb_name
  preserve_host_header                 = var.preserve_host_header
  security_groups                      = var.security_groups
  subnets                              = var.subnets
  xff_header_processing_mode           = var.xff_header_processing_mode

  access_logs {
    bucket  = var.access_logs_bucket
    enabled = var.access_logs_enabled
  }

  connection_logs {
    bucket  = var.connection_logs_bucket
    enabled = var.connection_logs_enabled
  }
}

resource "aws_lb_target_group" "this" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = var.health_check_matcher
  }

  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type = var.http_default_action_type
    redirect {
      port         = var.http_redirect_port
      protocol     = var.http_redirect_protocol
      status_code  = var.http_redirect_status_code
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.https_listener_port
  protocol          = var.https_listener_protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = var.https_default_action_type
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.hosted_zone_id
  name    = var.zone_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

