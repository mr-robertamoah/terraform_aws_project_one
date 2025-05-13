locals {
    tags = {
        Environment = var.environment
        Owner = "Robert Amoah"
        Project = "AWS Terraform Project One" 
        Module = "Security"
    }

    prefix = "${var.project_name}-${var.environment}"
}
