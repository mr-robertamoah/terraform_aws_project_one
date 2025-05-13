variable "project_name" {
  description = "The name of the project."
  type        = string
 }

variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, staging, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "rds_engine" {
  description = "The RDS engine type (e.g., mysql, postgres)."
  type        = string
  
}