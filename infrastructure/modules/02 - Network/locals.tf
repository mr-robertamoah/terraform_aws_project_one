locals {
  tags = {
    Environment = "dev"
    Owner = "Robert Amoah"
    Project = "AWS Terraform Project One" 
    Module = "Network"
  }

  # This is the CIDR block for the VPC. It is used to define the range of IP addresses that can be used within the VPC.
  everyWhere = {
    cidr_block: "0.0.0.0/0"
  }

  # This is the CIDR block for the VPC. It is used to define the range of IP addresses that can be used within the VPC.
  public_frontend_subnets = [for subnet in var.public_frontend_subnets: subnet.cidr_block]
  private_database_subnets = [for subnet in var.private_database_subnets: subnet.cidr_block]
  private_backend_subnets = [for subnet in var.private_backend_subnets: subnet.cidr_block]
}