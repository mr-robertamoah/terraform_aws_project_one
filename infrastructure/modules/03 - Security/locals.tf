locals {
    tags = {
        Environment = "dev"
        Owner = "Robert Amoah"
        Project = "AWS Terraform Project One" 
        Module = "Security"
    }

    prefix = "${var.project_name}-${var.environment}"

    everyWhere = {
        cidr_block: "0.0.0.0/0"
    }
}