# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "devopsapp-${var.environment}-cluster"

  tags = {
    Name        = "devopsapp-${var.environment}-cluster"
    Environment = var.environment
    Application = "devopsapp"
  }
}

# Backend Task Definition
resource "aws_ecs_task_definition" "backend" {
  family                   = "devopsapp-${var.environment}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${var.ecr_backend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "devopsapp-${var.environment}-backend"
    Environment = var.environment
    Application = "devopsapp"
  }
}

# Frontend Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "devopsapp-${var.environment}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.frontend_cpu
  memory                   = var.frontend_memory
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${var.ecr_frontend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "devopsapp-${var.environment}-frontend"
    Environment = var.environment
    Application = "devopsapp"
  }
}

# Backend ECS Service
resource "aws_ecs_service" "backend" {
  name            = "devopsapp-${var.environment}-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name        = "devopsapp-${var.environment}-backend-service"
    Environment = var.environment
    Application = "devopsapp"
  }
}

# Frontend ECS Service
resource "aws_ecs_service" "frontend" {
  name            = "devopsapp-${var.environment}-frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name        = "devopsapp-${var.environment}-frontend-service"
    Environment = var.environment
    Application = "devopsapp"
  }
}

# Security Group for ECS
resource "aws_security_group" "ecs" {
  name        = "devopsapp-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devopsapp-${var.environment}-ecs-sg"
    Environment = var.environment
    Application = "devopsapp"
  }
}
module "ecs" {
  source = "./modules/ecs"

  app_name    = var.app_name
  environment = var.environment
  desired_count = var.desired_count

  backend_task_definition_arn  = aws_ecs_task_definition.backend.arn
  frontend_task_definition_arn = aws_ecs_task_definition.frontend.arn
}