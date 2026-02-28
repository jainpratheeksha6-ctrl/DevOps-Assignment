############################
# Global
############################

variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

############################
# ECS Scaling
############################

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
}

############################
# Backend Config
############################

variable "backend_cpu" {
  description = "Backend CPU"
  type        = string
}

variable "backend_memory" {
  description = "Backend Memory"
  type        = string
}

variable "ecr_backend_repository_url" {
  description = "Backend ECR Image URL"
  type        = string
}

############################
# Frontend Config
############################

variable "frontend_cpu" {
  description = "Frontend CPU"
  type        = string
}

variable "frontend_memory" {
  description = "Frontend Memory"
  type        = string
}

variable "ecr_frontend_repository_url" {
  description = "Frontend ECR Image URL"
  type        = string
}

############################
# Networking
############################

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS deployment region"
  type        = string
}