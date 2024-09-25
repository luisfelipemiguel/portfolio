# Project README

## Overview
This project is a Terraform-based infrastructure automation solution that provisions and configures a set of Amazon Web Services (AWS) components necessary to run the [Outline](https://www.getoutline.com) application or any other containerized applications in AWS, with built-in database and caching services, load balancing, and monitoring. It deploys and manages services like Amazon RDS, Amazon ElastiCache, Amazon Elastic Load Balancing (ALB), AWS ECS (Fargate), and associated security groups. The solution enables a highly scalable and secure environment for running containerized applications in AWS, with built-in database and caching services, load balancing, and monitoring, as well as Slack-based authentication.

### Components Deployed and Managed
- **Amazon RDS**: Provides relational database management for the Outline application (PostgreSQL).
- **Amazon ElastiCache**: Sets up an in-memory cache (Redis) for optimizing application performance.
- **Application Load Balancer (ALB)**: Distributes incoming application traffic and manages SSL termination.
- **Amazon ECS (Fargate)**: Manages container orchestration and deployment for the Outline container.
- **Security Group Rules**: Defines security controls for communication between services.

Each module of the project is designed to be reusable, providing modular infrastructure as code (IaC). Below is a detailed explanation of each module and its purpose.

## Modules

### 1. ECS Module
**Path**: `./modules/ecs`

The ECS module provisions and configures an ECS cluster to run the Outline container using AWS Fargate.

- **Key Inputs**:
  - `ecs_cluster_name`: Name of the ECS cluster.
  - `task_definition_family`: Defines the family of the task definition for the Outline container.
  - `docker_image`: Docker image used for the Outline application.
  - `ecs_task_cpu/ecs_task_memory`: CPU and memory configuration for tasks.
  - `desired_count`: Number of ECS tasks to run.
  - `subnets`, `security_groups`: Networking configuration.
  - `environment`: Environment variables injected into the container, defined in `locals.tf`, including:
    - `DATABASE_URL`: Connection string to the PostgreSQL RDS database.
    - `REDIS_URL`: Connection string to the Redis cache in ElastiCache.
    - `SLACK_CLIENT_ID`, `SLACK_CLIENT_SECRET`: Slack OAuth credentials for authentication.
    - `SLACK_VERIFICATION_TOKEN`: Token for verifying requests from Slack.
    - `SLACK_APP_ID`: The Slack app identifier.
    - `URL`: Base URL of the Outline application.

- **Main Resources**:
  - `aws_ecs_cluster`: Provisions the ECS cluster to host the Outline application.
  - `aws_ecs_task_definition`: Defines the ECS tasks and container specifications.
  - `aws_ecs_service`: Manages the ECS service that runs the tasks.
  - `aws_cloudwatch_log_group`: Configures logging for ECS tasks.

### 2. RDS Module
**Path**: `./modules/rds`

This module provisions an Amazon RDS instance to handle the PostgreSQL database that the Outline application uses.

- **Key Inputs**:
  - `db_identifier`: Unique identifier for the RDS instance.
  - `db_name`: Name of the database.
  - `db_username/db_password`: Credentials for database access.
  - `engine`: Database engine (e.g., `postgres`).
  - `multi_az`: Enables Multi-AZ deployment for high availability.
  - `backup_retention_period`: Number of days to retain backups.
  - `storage_encrypted`: Enables encryption of RDS storage.
  - `db_instance_class`: Defines the instance class for performance (e.g., `db.t3.micro`).
  - `publicly_accessible`: Configures whether the instance is accessible over the internet.

- **Main Resources**:
  - `aws_db_instance`: Provisions the database instance hosting the Outline database.
  - `aws_db_subnet_group`: Configures subnets for database networking.

### 3. ElastiCache Module
**Path**: `./modules/elasticache`

This module sets up an ElastiCache cluster, which is used by the Outline application for caching via Redis.

- **Key Inputs**:
  - `elasticache_cluster_id`: Unique identifier for the ElastiCache cluster.
  - `engine`: Cache engine (Redis).
  - `engine_version`: Cache engine version.
  - `num_cache_nodes`: Number of cache nodes to deploy.
  - `subnet_group_name`: Defines the cache subnet group.
  - `security_group_ids`: Security groups for network access control.

- **Main Resources**:
  - `aws_elasticache_cluster`: Creates the Redis cluster.
  - `aws_elasticache_subnet_group`: Configures subnets for the cluster.

### 4. ALB Module
**Path**: `./modules/alb`

This module provisions an Application Load Balancer (ALB) for distributing traffic to the ECS services and handling HTTP and HTTPS traffic for the Outline application. The ALB listens on port 80 and redirects traffic to HTTPS on port 443, forwarding requests to the target group to ensure secure communication.

- **Key Inputs**:
  - `vpc_id`: VPC where the load balancer will be deployed.
  - `certificate_arn`: ARN of the SSL certificate for HTTPS.
  - `http_listener_port/https_listener_port`: Ports for HTTP (80) and HTTPS (443).
  - `ssl_policy`: The SSL/TLS policy for secure communications.
  - `target_group_name`: Name of the target group to forward requests to.
  - `health_check_path`: Endpoint for health check monitoring.

- **Main Resources**:
  - `aws_lb`: Provisions the ALB.
  - `aws_lb_target_group`: Defines the target group for traffic distribution.
  - `aws_lb_listener`: Configures HTTP/HTTPS listeners and traffic redirection.

### 5. Security Module
**Path**: `./modules/security`

This module manages security group rules that control traffic between different services (ALB, ECS, RDS, and ElastiCache).

- **Key Inputs**:
  - `security_groups`: List of security group IDs.
  - `http_port/https_port`: Ports for web traffic (ALB).
  - `rds_port`: Database port for RDS.
  - `elasticache_port`: Cache port for ElastiCache.
  - `fargate_port`: Port for the ECS Fargate tasks.

- **Main Resources**:
  - `aws_security_group_rule`: Defines rules for ingress traffic between components, ensuring that:
    - HTTP (80) and HTTPS (443) traffic are allowed to the ALB from any source.
    - Fargate tasks can connect to the ElastiCache cluster on the Redis port.
    - The ALB can forward traffic to the Outline container running on Fargate.
    - Fargate tasks can connect to the RDS instance over the PostgreSQL port.

## Summary of Resources
- **RDS**: PostgreSQL database instance.
- **ElastiCache**: Redis caching service.
- **ALB**: Application Load Balancer for handling HTTP/HTTPS traffic.
- **ECS**: Containerized deployment of the Outline application using Fargate.
- **Security Groups**: Rules that secure the traffic between various services, ensuring that each component can communicate only with the necessary services.

By setting up these modules, this project ensures a secure and scalable environment for deploying Outline, leveraging AWS managed services like RDS, ElastiCache, and ECS with Fargate. The ALB simplifies traffic management and SSL termination, while the security groups ensure proper traffic isolation.

### Note: 
This project requires the creation of a hosted zone and a DNS record in Route 53 that links the desired domain to the Application Load Balancer (ALB).
