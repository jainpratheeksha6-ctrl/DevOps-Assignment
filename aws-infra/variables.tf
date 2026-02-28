variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "backend-app"
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 1
}