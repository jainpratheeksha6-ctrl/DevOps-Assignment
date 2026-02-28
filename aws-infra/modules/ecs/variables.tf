variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "backend_task_definition_arn" {
  type = string
}

variable "frontend_task_definition_arn" {
  type = string
}