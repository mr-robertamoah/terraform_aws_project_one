output "ecs_execution_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_execution_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.ecs_task_role.name
}

output "ecs_task_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_execution_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "jump_server_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.jump_server_role.name
}

output "jump_server_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.jump_server_role.arn
}

output "s3_access_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.s3_access_role.name
}

output "s3_access_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.s3_access_role.arn
}

output "jump_server_instance_profile_name" {
  description = "The name of the IAM instance profile."
  value       = aws_iam_instance_profile.jump_server_instance_profile.name
}

output "jump_server_instance_profile_arn" {
  description = "The ARN of the IAM instance profile."
  value       = aws_iam_instance_profile.jump_server_instance_profile.arn
}