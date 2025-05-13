variable "project_name" {
  description = "The name of the project."
  type        = string
 }

variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, staging, prod)."
  type        = string
}

# AZ Count
variable "az_count" {
  description = "Number of AZs to use"
  type        = number
}

# Jump Server Instance Type
variable "jump_server_instance_type" {
  description = "EC2 instance type for the jump server"
  type        = string
  default     = "t3.micro"
}

# Variable for Container Port
variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
}

# Variable ALB HTTPS Listener Port
variable "alb_https_listener_port" {
  description = "HTTPS port for ALB listener"
  type        = number
}

# Variable for wildcard Domain Name
variable "wildcard_domain_name" {
  description = "Wildcard domain name for ALB"
  type        = string
}

# Key Name
variable "key_name" {
  description = "Name of the key pair to use for the jump server"
  type        = string
}

# Public Key Path
variable "public_key_path" {
  description = "Path to the public key file for the jump server"
  type        = string
}