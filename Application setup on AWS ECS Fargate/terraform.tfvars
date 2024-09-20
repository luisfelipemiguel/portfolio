# Generic Variables

aws_region      = "us-east-1"
subnets         = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890", "subnet-0987654321fedcba0"]
security_groups = ["sg-12345678"]
url             = "https://example.com"
vpc_id          = "vpc-1234567890abcdef0"


# ElastiCache Module

ec_environment         = "production"
elasticache_cluster_id = "elasticache-example"
engine_ec              = "redis"
engine_version         = "6.2"
node_type              = "cache.t3.micro"
num_cache_nodes        = 1
port                   = 6379
subnet_group_name      = "elasticache-subnet-group"
subnet_ids             = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890", "subnet-0987654321fedcba0"]


# RDS Module

backup_retention_period = 7
db_allocated_storage    = 20
db_identifier           = "example-db"
db_instance_class       = "db.t3.micro"
db_name                 = "example"
db_password             = "dummy_password"
db_username             = "example_user"
engine_db               = "postgres"
multi_az                = false
publicly_accessible     = false
skip_final_snapshot     = true
storage_encrypted       = true


# ALB Module

access_logs_bucket               = "example-logs"
access_logs_enabled              = false
alb_name                         = "Example-ALB"
certificate_arn                  = "arn:aws:acm:us-east-1:123456789012:certificate/example-certificate"
connection_logs_bucket           = "example-connection-logs"
connection_logs_enabled          = false
desync_mitigation_mode           = "defensive"
drop_invalid_header_fields       = false
enable_cross_zone_load_balancing = true
enable_deletion_protection       = false
enable_http2                     = true
evaluate_target_health           = true
health_check_enabled             = true
health_check_healthy_threshold   = 2
health_check_interval            = 30
health_check_matcher             = "200,301"
health_check_path                = "/"
health_check_timeout             = 5
health_check_unhealthy_threshold = 2
hosted_zone_id                   = "Z1234567890ABCDE"
http_default_action_type         = "redirect"
http_listener_port               = 80
http_listener_protocol           = "HTTP"
http_redirect_port               = "443"
http_redirect_protocol           = "HTTPS"
http_redirect_status_code        = "HTTP_301"
https_default_action_type        = "forward"
https_listener_port              = 443
https_listener_protocol          = "HTTPS"
idle_timeout                     = 60
internal                         = false
ip_address_type                  = "ipv4"
load_balancer_type               = "application"
preserve_host_header             = false
ssl_policy                       = "ELBSecurityPolicy-2016-08"
stickiness_cookie_duration       = 3600
stickiness_type                  = "lb_cookie"
target_group_name                = "Example-TG"
target_group_port                = 80
target_group_protocol            = "HTTP"
target_type                      = "ip"
xff_header_processing_mode       = "append"
zone_name                        = "example.cloud"


# ECS Module

assign_public_ip                = true
container_name                  = "example"
desired_count                   = 1
docker_image                    = "docker.example.com/example:latest"
ecs_cluster_name                = "example-cluster"
ecs_container_cpu               = 512
ecs_container_memory            = 1024
ecs_task_cpu                    = 1024
ecs_task_memory                 = 2048
ecs_task_storage                = 21
force_https                     = true
iam_role_managed_policy_arns    = ["arn:aws:iam::123456789012:policy/example-policy"]
iam_role_name                   = "example-task-execution-role"
log_group_name                  = "/ecs/example"
log_group_retention             = 7
log_stream_prefix               = "ecs"
secret_key                      = "dummy_secret_key"
service_name                    = "example"
slack_app_id                    = "A123456789"
slack_client_id                 = "1234567890.1234567890123"
slack_client_secret             = "dummy_slack_secret"
slack_message_actions           = true 
slack_verification_token        = "dummy_verification_token"
task_definition_compatibilities = ["FARGATE"]
task_definition_family          = "example"
utils_secret                    = "dummy_utils_secret"


# Security Module

elasticache_port = 6379
fargate_port     = 3000
http_port        = 80
https_port       = 443
rds_port         = 5432
