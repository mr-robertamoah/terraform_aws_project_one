output "vpc_id" {
  value = aws_vpc.vpc_network.id
}

output "vpc_arn" {
  value = aws_vpc.vpc_network.arn
}

output "public_frontend_subnet_ids" {
  value = [for subnet in aws_subnet.vpc_network_public_frontend_subnets : subnet.id]
}

output "private_backend_subnet_ids" {
  value = [for subnet in aws_subnet.vpc_network_private_backend_subnets: subnet.id]
}

output "private_database_subnet_ids" {
  value = [for subnet in aws_subnet.vpc_network_private_database_subnets: subnet.id]
}
