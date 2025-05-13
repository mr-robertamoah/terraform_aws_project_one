variable "project_name" {
  description = "The name of the project."
  type        = string
 }

variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, staging, prod)."
  type        = string
}

variable "ecs_execution_role_policy_arns" {
  description = "List of ARNs for the ECS execution role policies."
  type        = list(string)
}

variable "ecs_task_execution_role_policy_arns" {
  description = "List of ARNs for the ECS task execution role policies."
  type        = list(string)
}

variable "ecs_task_role_policy_arns" {
  description = "List of ARNs for the ECS task role policies."
  type        = list(string)
}

variable "jump_server_role_policy_arns" {
  description = "List of ARNs for the jump server role policies."
  type        = list(string)
}

variable "s3_access_role_policy_arns" {
  description = "List of ARNs for the S3 role policies."
  type        = list(string)
}