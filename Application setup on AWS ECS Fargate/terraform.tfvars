# Generic Variables

aws_region      = "eu-central-1"
subnets         = ["subnet-12345678", "subnet-23456789", "subnet-34567890"]
security_groups = ["sg-98765432"]
url             = "https://docs.example.com"
vpc_id          = "vpc-123abc456def"


# ElastiCache Module

ec_environment         = "development"
elasticache_cluster_id = "elasticache-test"
engine_ec              = "redis"
engine_version         = "5.0"
node_type              = "cache.t2.micro"
num_cache_nodes        = 1
port                   = 6379
subnet_group_name      = "elasticache-subnet-group-test"
subnet_ids             = ["subnet-12345678", "subnet-23456789", "subnet-34567890"]


# RDS Module

backup_retention_period = 7
db_allocated_storage    = 20
db_identifier           = "test-db"
db_instance_class       = "db.t2.micro"
db_name                 = "testdb"
db_password             = "Password@123"
db_username             = "test_user"
engine_db               = "postgresql"
multi_az                = false
publicly_accessible     = false
skip_final_snapshot     = true
storage_encrypted       = true


# ALB Module

access_logs_bucket               = "logs-bucket"
access_logs_enabled              = true
alb_name                         = "Test-ALB"
certificate_arn                  = "arn:aws:acm:eu-central-1:123456789012:certificate/abcd1234-5678-90ef-ghij-klmnopqrstuv"
connection_logs_bucket           = "connection-logs-bucket"
connection_logs_enabled          = true
desync_mitigation_mode           = "defensive"
drop_invalid_header_fields       = true
enable_cross_zone_load_balancing = false
enable_deletion_protection       = true
enable_http2                     = false
evaluate_target_health           = false
health_check_enabled             = true
health_check_healthy_threshold   = 3
health_check_interval            = 30
health_check_matcher             = "200,301"
health_check_path                = "/health"
health_check_timeout             = 5
health_check_unhealthy_threshold = 2
hosted_zone_id                   = "Z123456789ABCDEF"
http_default_action_type         = "redirect"
http_listener_port               = 80
http_listener_protocol           = "HTTP"
http_redirect_port               = "443"
http_redirect_protocol           = "HTTPS"
http_redirect_status_code        = "HTTP_302"
https_default_action_type        = "forward"
https_listener_port              = 443
https_listener_protocol          = "HTTPS"
idle_timeout                     = 60
internal                         = false
ip_address_type                  = "ipv4"
load_balancer_type               = "application"
preserve_host_header             = true
ssl_policy                       = "ELBSecurityPolicy-2016-08"
stickiness_cookie_duration       = 3600
stickiness_type                  = "lb_cookie"
target_group_name                = "Test-TG"
target_group_port                = 80
target_group_protocol            = "HTTP"
target_type                      = "ip"
xff_header_processing_mode       = "append"
zone_name                        = "example.com"


# ECS Module

assign_public_ip                = true
container_name                  = "test-container"
desired_count                   = 1
docker_image                    = "docker.example.com/testimage:latest"
ecs_cluster_name                = "test-cluster"
ecs_container_cpu               = 512
ecs_container_memory            = 1024
ecs_task_cpu                    = 1024
ecs_task_memory                 = 2048
ecs_task_storage                = 21
force_https                     = true
iam_role_managed_policy_arns    = ["arn:aws:iam::123456789012:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
iam_role_name                   = "ecs-task-execution-role-test"
launch_type                     = "FARGATE"
log_group_name                  = "/ecs/test"
log_group_retention             = 7
log_stream_prefix               = "ecs"
network_mode                    = "awsvpc"
secret_key                      = "abcdef1234567890abcdef1234567890"
service_name                    = "test-service"
slack_app_id                    = "A123456789"
slack_client_id                 = "123456789.9876543210"
slack_client_secret             = "abcd1234efgh5678ijkl9101mnopqrstu"
slack_message_actions           = true 
slack_verification_token        = "token123456"
task_definition_compatibilities = ["FARGATE"]
task_definition_family          = "test"
utils_secret                    = "secret123456abcdef"


# Security Module

elasticache_port = 6379
fargate_port     = 3000
http_port        = 80
https_port       = 443
rds_port         = 5432
