app_name    = "devopsapp"
environment = "dev"

desired_count = 1

backend_cpu    = "256"
backend_memory = "512"

frontend_cpu    = "256"
frontend_memory = "512"

ecr_backend_repository_url  = "359062857005.dkr.ecr.ap-south-1.amazonaws.com/backend-app"
ecr_frontend_repository_url = "359062857005.dkr.ecr.ap-south-1.amazonaws.com/frontend-app"

vpc_id = "vpc-07d102c3c7303cec3"

subnet_ids = [
  "subnet-0d3fe920e9c82d9de",
  "subnet-09577e31055cfc7e4"
]
aws_region = "ap-south-1"