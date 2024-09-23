locals {
  environment = [
    {
      name  = "DATABASE_URL"
      value = "postgresql://${module.rds.db_username}:${module.rds.db_password}@${module.rds.db_instance_endpoint}/${module.rds.db_name}"
    },
    {
      name  = "FORCE_HTTPS"
      value = var.force_https
    },
    {
      name  = "REDIS_URL"
      value = "redis://${module.elasticache.elasticache_endpoint}:${module.elasticache.elasticache_port}"
    },
    {
      name  = "SECRET_KEY"
      value = var.secret_key
    },
    {
      name  = "SLACK_CLIENT_ID"
      value = var.slack_client_id
    },
    {
      name  = "SLACK_CLIENT_SECRET"
      value = var.slack_client_secret
    },
    {
      name  = "SLACK_VERIFICATION_TOKEN"
      value = var.slack_verification_token
    },
    {
      name  = "SLACK_APP_ID"
      value = var.slack_app_id
    },
    {
      name  = "SLACK_MESSAGE_ACTIONS"
      value = var.slack_message_actions
    },
    {
      name  = "URL"
      value = var.url
    },
    {
      name  = "UTILS_SECRET"
      value = var.utils_secret
    }
  ]

  ec_tags_cluster = {
    Name            = "${var.ec_environment}-elasticache-cluster"
    ec_environment  = var.ec_environment
  }

  ec_tags_subnet_group = {
    Name = "${var.ec_environment}-elasticache-subnet-group"
  }
}
