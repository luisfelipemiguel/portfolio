# Generic Variables

aws_region      = "eu-central-1"
subnets         = ["subnet-0b45951eb11907e8a", "subnet-04dafa1cd078b4560", "subnet-0d9df89e3869c9576"]
security_groups = ["sg-028bc184dfbf297d1"]
url             = "https://docs.out.cloud"
vpc_id          = "vpc-0ecef0802341baec7"


# ElastiCache Module

ec_environment         = "production"
elasticache_cluster_id = "elasticache-outline"
engine_ec              = "redis"
engine_version         = "6.2"
node_type              = "cache.t3.micro"
num_cache_nodes        = 1
port                   = 6379
subnet_group_name      = "elasticache-subnet-group"
subnet_ids             = ["subnet-0b45951eb11907e8a", "subnet-04dafa1cd078b4560", "subnet-0d9df89e3869c9576"]


# RDS Module

backup_retention_period = 7
db_allocated_storage    = 20
db_identifier           = "outline-db"
db_instance_class       = "db.t3.micro"
db_name                 = "outline"
db_password             = "cesae123"
db_username             = "outline_user"
engine_db               = "postgres"
multi_az                = false
publicly_accessible     = false
skip_final_snapshot     = true
storage_encrypted       = true


# ALB Module

access_logs_bucket               = ""
access_logs_enabled              = false
alb_name                         = "Outline-ALB"
certificate_arn                  = "arn:aws:acm:eu-central-1:975050136162:certificate/3d2af104-dbbf-4184-ba1f-fbeaeea769e6"
connection_logs_bucket           = ""
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
hosted_zone_id                   = "Z050043425MDD7AXCC08L"
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
target_group_name                = "Outline-TG"
target_group_port                = 80
target_group_protocol            = "HTTP"
target_type                      = "ip"
xff_header_processing_mode       = "append"
zone_name                        = "docs.out.cloud"


# ECS Module

assign_public_ip                = true
container_name                  = "outline"
desired_count                   = 1
docker_image                    = "docker.getoutline.com/outlinewiki/outline:latest"
ecs_cluster_name                = "outline-cluster"
ecs_container_cpu               = 512
ecs_container_memory            = 1024
ecs_task_cpu                    = 1024
ecs_task_memory                 = 2048
ecs_task_storage                = 21
force_https                     = true
iam_role_managed_policy_arns    = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
iam_role_name                   = "ecs-task-execution-role"
launch_type                     = "FARGATE"
log_group_name                  = "/ecs/outline"
log_group_retention             = 7
log_stream_prefix               = "ecs"
network_mode                    = "awsvpc"
secret_key                      = "7a01037c27cf3fc00940c8ea1e8b416661517845420b0a7bcf41142920badc83"
service_name                    = "outline"
slack_app_id                    = "A078E4MCB9B"
slack_client_id                 = "440082125316.7286157419317"
slack_client_secret             = "9e2e9ef3a98c70dca9676cde7a576082"
slack_message_actions           = true 
slack_verification_token        = "d0tIzOmhd7VbJ8DgfKqJBNFV"
task_definition_compatibilities = ["FARGATE"]
task_definition_family          = "outline"
utils_secret                    = "1deb6935b72fccbd2efc61ce9b02da57b4984966999ea94554b655f216228ad6"


# Security Module

elasticache_port = 6379
fargate_port     = 3000
http_port        = 80
https_port       = 443
rds_port         = 5432