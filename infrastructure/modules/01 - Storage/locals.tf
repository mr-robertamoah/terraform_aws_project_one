locals {
  tags = {
    Environment = "dev"
    Owner = "Robert Amoah"
    Project = "AWS Terraform Project One" 
    Module = "Storage"
  }

  prefix = "${var.project_name}-${var.environment}"
}