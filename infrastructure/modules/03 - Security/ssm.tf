# Store jump server security group id in ssm
resource "aws_ssm_parameter" "jump_server_sg_id" {
  name  = "/${local.prefix}/jump_server_sg/id"
  type  = "String"
  value = aws_security_group.jump_server_sg.id
}

# Store alb security group id in ssm
resource "aws_ssm_parameter" "alb_sg_id" {
  name  = "/${local.prefix}/alb_sg/id"
  type  = "String"
  value = aws_security_group.alb_sg.id
}

# Store waf arn in ssm
resource "aws_ssm_parameter" "waf_arn" {
  name  = "/${local.prefix}/waf/arn"
  type  = "String"
  value = aws_wafv2_web_acl.waf.arn
}
