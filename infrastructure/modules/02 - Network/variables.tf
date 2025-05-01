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
  type = map(object({
    cidr_block = string
  }))
}

variable "private_backend_subnets" {
  description = "this is a map of subnet objects to used to create private subnets for backend"
  type = map(object({
    cidr_block = string
  }))
}

variable "private_database_subnets" {
  description = "this is a map of subnet objects to used to create private subnets for database"
  type = map(object({
    cidr_block = string
  }))
}
