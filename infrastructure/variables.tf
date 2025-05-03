variable "project_name" {
  description = "The name of the project."
  type        = string
 }

variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, staging, prod)."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type = string
}

variable "aws_profile" {
  description = "The AWS profile to use for authentication."
  type = string
}

variable "bucket_name" {
  description = "the name of the s3 bucket meant for logging"
  type = string
}

variable "enable_versioning" {
  description = "enable versioning for the s3 bucket"
  type = bool
  default = false
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "public_frontend_subnets" {
  description = "this is a map of subnet objects to used to create public subnets for frontend"
  type = list(string)
}

variable "private_backend_subnets" {
  description = "this is a map of subnet objects to used to create private subnets for backend"
  type = list(string)
}

variable "private_database_subnets" {
  description = "this is a map of subnet objects to used to create private subnets for database"
  type = list(string)
}

variable "rds_engine" {
  description = "The RDS engine type (e.g., mysql, postgres)."
  type        = string
  
}
