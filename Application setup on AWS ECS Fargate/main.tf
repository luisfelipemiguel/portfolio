module "rds" {
  source             = "./modules/rds"
  ecs_cluster_name   = var.ecs_cluster_name
  db_identifier      = var.db_identifier
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  subnet_ids         = var.subnets
  security_groups    = var.security_groups
  engine             = var.engine_db
  backup_retention_period = var.backup_retention_period
  db_allocated_storage = var.db_allocated_storage
  multi_az = var.multi_az
  publicly_accessible = var.publicly_accessible
  skip_final_snapshot = var.skip_final_snapshot
  storage_encrypted = var.storage_encrypted
  db_instance_class = var.db_instance_class
}

module "elasticache" {
  source                  = "./modules/elasticache"
  elasticache_cluster_id  = var.elasticache_cluster_id
  engine                  = var.engine_ec
  engine_version          = var.engine_version
  node_type               = var.node_type
  port                    = var.port
  subnet_group_name       = var.subnet_group_name
  subnet_ids              = var.subnet_ids
  security_group_ids      = var.security_groups
  ec_environment          = var.ec_environment
  num_cache_nodes         = var.num_cache_nodes
}

module "alb" {
  source               = "./modules/alb"
  vpc_id               = var.vpc_id
  subnets              = var.subnets
  security_groups      = var.security_groups
  certificate_arn      = var.certificate_arn
  hosted_zone_id       = var.hosted_zone_id
  zone_name            = var.zone_name

  desync_mitigation_mode                = var.desync_mitigation_mode
  drop_invalid_header_fields            = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing      = var.enable_cross_zone_load_balancing
  enable_deletion_protection            = var.enable_deletion_protection
  enable_http2                          = var.enable_http2
  idle_timeout                          = var.idle_timeout
  internal                              = var.internal
  ip_address_type                       = var.ip_address_type
  load_balancer_type                    = var.load_balancer_type
  alb_name                              = var.alb_name
  preserve_host_header                  = var.preserve_host_header
  xff_header_processing_mode            = var.xff_header_processing_mode
  access_logs_bucket                    = var.access_logs_bucket
  access_logs_enabled                   = var.access_logs_enabled
  connection_logs_bucket                = var.connection_logs_bucket
  connection_logs_enabled               = var.connection_logs_enabled
  target_group_name                     = var.target_group_name
  target_group_port                     = var.target_group_port
  target_group_protocol                 = var.target_group_protocol
  target_type                           = var.target_type
  health_check_enabled                  = var.health_check_enabled
  health_check_healthy_threshold        = var.health_check_healthy_threshold
  health_check_unhealthy_threshold      = var.health_check_unhealthy_threshold
  health_check_timeout                  = var.health_check_timeout
  health_check_interval                 = var.health_check_interval
  health_check_path                     = var.health_check_path
  health_check_matcher                  = var.health_check_matcher
  stickiness_type                       = var.stickiness_type
  stickiness_cookie_duration            = var.stickiness_cookie_duration
  http_listener_port                    = var.http_listener_port
  http_listener_protocol                = var.http_listener_protocol
  http_default_action_type              = var.http_default_action_type
  http_redirect_port                    = var.http_redirect_port
  http_redirect_protocol                = var.http_redirect_protocol
  http_redirect_status_code             = var.http_redirect_status_code
  https_listener_port                   = var.https_listener_port
  https_listener_protocol               = var.https_listener_protocol
  ssl_policy                            = var.ssl_policy
  https_default_action_type             = var.https_default_action_type
  evaluate_target_health                = var.evaluate_target_health
}

module "security" {
  source = "./modules/security"
  security_groups           = var.security_groups
  http_port                 = var.http_port
  https_port                = var.https_port
  elasticache_port          = var.elasticache_port
  fargate_port              = var.fargate_port
  rds_port                  = var.rds_port
}

module "ecs" {
  source                 = "./modules/ecs"
  aws_region             = var.aws_region
  task_definition_family = var.task_definition_family
  log_group_name         = var.log_group_name
  service_name           = var.service_name
  container_name         = var.container_name
  docker_image           = var.docker_image
  subnets                = var.subnets
  security_groups        = var.security_groups
  vpc_id                 = var.vpc_id
  ecs_task_storage       = var.ecs_task_storage
  ecs_task_cpu           = var.ecs_task_cpu
  ecs_task_memory        = var.ecs_task_memory
  ecs_container_memory   = var.ecs_container_memory
  ecs_container_cpu      = var.ecs_container_cpu
  ecs_cluster_name       = var.ecs_cluster_name
  target_group_arn       = module.alb.target_group_arn
  fargate_port           = var.fargate_port
  environment            = local.environment
  assign_public_ip       = var.assign_public_ip
  desired_count          = var.desired_count
  iam_role_managed_policy_arns = var.iam_role_managed_policy_arns
  iam_role_name          = var.iam_role_name
  log_group_retention    = var.log_group_retention
  log_stream_prefix      = var.log_stream_prefix
  task_definition_compatibilities = var.task_definition_compatibilities
  
  depends_on             = [module.rds, module.elasticache, module.alb, module.security]
}