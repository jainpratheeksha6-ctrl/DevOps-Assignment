terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-pratheeksha123"
    key            = "aws/backend.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}