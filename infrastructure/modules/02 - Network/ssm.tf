resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.tags.Project}-vpc-id"
  type  = "String"
  value = aws_vpc.vpc_network.id

  tags = local.tags  
}

resource "aws_ssm_parameter" "public_frontend_subnet_ids" {
  name  = "${local.tags.Project}-public-frontend-subnet-ids"
  type  = "StringList"
  value = join(",", [for subnet in aws_subnet.vpc_network_public_frontend_subnets : subnet.id])

  tags = local.tags 
}

resource "aws_ssm_parameter" "private_backend_subnet_ids" {
  name  = "${local.tags.Project}-private-backend-subnet-ids"
  type  = "StringList"
  value = join(",", [for subnet in aws_subnet.vpc_network_private_backend_subnets : subnet.id])

  tags = local.tags 
}

resource "aws_ssm_parameter" "private_database_subnet_ids" {
  name  = "${local.tags.Project}-private-database-subnet-ids"
  type  = "StringList"
  value = join(",", [for subnet in aws_subnet.vpc_network_private_database_subnets : subnet.id])

  tags = local.tags 
}

resource "aws_ssm_parameter" "elastic_ip_ids" {
  count = length(var.public_frontend_subnets)
  name  = "${local.tags.Project}-elastic-ip-${count.index}"
  type  = "String"
  value = aws_eip.vpc_network_ng_eip[count.index].id

  tags = local.tags
}

resource "aws_ssm_parameter" "elastic_ips" {
  count = length(var.public_frontend_subnets)
  name  = "${local.tags.Project}-elastic-ip-${count.index}"
  type  = "String"
  value = aws_eip.vpc_network_ng_eip[count.index].public_ip

  tags = local.tags
}