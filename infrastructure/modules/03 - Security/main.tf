resource "aws_security_group" "jump_server_sg" {
  name        = "${local.prefix}-jump"
  description = "Jump security group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-jump-server"
    })
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# This rule allows inbound traffic on port 22 (SSH) from my Ip with a cidr of 16 to the jump server security group
resource "aws_security_group_rule" "jump_server_sg_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.jump_server_sg.id
  cidr_blocks        = [ local.myIp.cidr_block ]
  
}

# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "${local.prefix}-alb"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-alb"
    })
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
}

# This rule allows inbound traffic on port 22 (SSH) from the jumpstart server security group to the ALB security group
resource "aws_security_group_rule" "alb_sg_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  source_security_group_id = aws_security_group.jump_server_sg.id
  
}

# This rule allows inbound traffic on port 80 (HTTP) from the internet to the ALB security group
resource "aws_security_group_rule" "alb_sg_http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks = [ local.everyWhere.cidr_block ]
  
}

# This rule allows inbound traffic on port 443 (HTTPS) from the internet to the ALB security group
resource "aws_security_group_rule" "alb_sg_https_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks = [ local.everyWhere.cidr_block ]
  
}

# Create a security group for the ECS cluster
resource "aws_security_group" "ecs_sg" {
  name        = "${local.prefix}-ecs"
  description = "ecs security group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-ecs"
    })
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
}

# This rule allows inbound traffic on port 22 (SSH) from the jumpstart server security group to the ALB security group
resource "aws_security_group_rule" "ecs_sg_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.jump_server_sg.id
  
}

# This rule allows inbound traffic on port 80 (HTTP) from the jumpstart server security group to the ALB security group
resource "aws_security_group_rule" "ecs_sg_http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.jump_server_sg.id
  
}

# This rule allows inbound traffic on port 443 (HTTPS) from the jumpstart server security group to the ALB security group
resource "aws_security_group_rule" "ecs_sg_https_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.jump_server_sg.id
  
}

resource "aws_security_group" "rds_sg" {
  name        = "${local.prefix}-rds"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-rds"
    })
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
}

# This rule allows inbound traffic on port 22 (SSH) from the jumpstart server security group to the ALB security group
resource "aws_security_group_rule" "rds_sg_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.jump_server_sg.id
  
}

# This rule allows inbound traffic on a port depending on the RDS engine from the ECS security group to the RDS security group
resource "aws_security_group_rule" "rds_sg_db_rule" {
  type              = "ingress"
  from_port         = var.rds_engine == "mysql" ? 3306 : var.rds_engine == "postgres" ? 5432 : 0
  to_port           = var.rds_engine == "mysql" ? 3306 : var.rds_engine == "postgres" ? 5432 : 0
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  
}

# Create and attach WAF to the ALB security group to block bad requests
resource "aws_wafv2_web_acl" "waf" {
  name        = "${local.prefix}-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.prefix}-waf"
    sampled_requests_enabled    = true
  }
  rule {
    name     = "rate-limit"
    priority = 1
    action {
      count {}
    }
    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.prefix}-waf-rate-limit"
      sampled_requests_enabled    = true
    }
  }
}
