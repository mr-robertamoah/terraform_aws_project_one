output "jump_server_sg_id" {
  value = aws_security_group.jump_server_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "my_ip" {
  value = local.ip
}

output "my_ip_cidr_block" {
  value = local.myIp.cidr_block
}