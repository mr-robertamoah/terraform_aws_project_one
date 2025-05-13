data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Jump server instance profile
data "aws_iam_instance_profile" "jump_server_instance_profile" {
  name = "${local.prefix}-jump-server-instance-profile"
}

# Jump server subnet
data "aws_subnet" "jumpstart_public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${local.prefix}-public-frontend-subnet-*"]
  }
}

# Jump server security group
data "ssm_parameter" "jump_server_sg" {
  name = "/${local.prefix}/jump_server_sg/id"
}

# ALB security group
data "ssm_parameter" "alb_sg" {
  name = "/${local.prefix}/alb_sg/id"
}

# VPC ID
data "ssm_parameter" "vpc_id" {
  name = "/${local.prefix}/vpc-id"
}

# Subnet IDs for public frontend
data "ssm_parameter" "public_frontend_subnet_ids" {
  name = "/${local.prefix}/public-frontend-subnet-ids"
}

# ACM certificate ARN
data "aws_acm_certificate" "certificate" {
  domain   = var.wildcard_domain_name
  most_recent = true
  statuses = ["ISSUED"]
  types = ["AMAZON_ISSUED"]
}

# WAF arn
data "ssm_parameter" "waf_arn" {
  name = "/${local.prefix}/waf/arn"
}
