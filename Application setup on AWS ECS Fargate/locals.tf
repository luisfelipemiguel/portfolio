locals {
  environment = [
    {
      name  = "DATABASE_URL"
      value = module.rds.database_url
    },
    {
      name  = "FORCE_HTTPS"
      value = var.force_https
    },
    {
      name  = "REDIS_URL"
      value = module.elasticache.elasticache_url
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
}