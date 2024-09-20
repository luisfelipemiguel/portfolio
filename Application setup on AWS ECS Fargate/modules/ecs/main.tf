# Create a CloudWatch log group for ECS
resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.log_group_retention
}

# Define the IAM Role for ECS Task Execution
resource "aws_iam_role" "this" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Statement = [ {
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    } ]
    Version = "2012-10-17"
  })

  managed_policy_arns = var.iam_role_managed_policy_arns
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

# Define ECS Task Definition with `awsvpc` network mode
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_definition_family
  requires_compatibilities = var.task_definition_compatibilities
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  ephemeral_storage {
    size_in_gib = var.ecs_task_storage
  }
  execution_role_arn = aws_iam_role.this.arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = var.docker_image
    essential = true
    memory    = var.ecs_container_memory
    cpu       = var.ecs_container_cpu
    portMappings = [{
      containerPort = var.fargate_port
      hostPort      = var.fargate_port
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.log_stream_prefix
      }
    }
    # Conditionally include the environment variables only if not empty
    environment = length(var.environment) > 0 ? var.environment : null
  }])
}

# Define ECS Service
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.fargate_port
  }
}
