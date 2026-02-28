terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-pratheeksha123"
    key            = "aws-infra/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
