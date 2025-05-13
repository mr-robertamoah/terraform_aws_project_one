resource "aws_vpc" "vpc_network" {
  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-vpc"
  })
}

resource "aws_internet_gateway" "igw_network" {
  vpc_id = aws_vpc.vpc_network.id

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-igw"
  })
}

resource "aws_subnet" "vpc_network_public_frontend_subnets" {
  count = length(local.public_frontend_subnets)

  vpc_id = aws_vpc.vpc_network.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  cidr_block = local.public_frontend_subnets[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-public-frontend-subnet-${count.index}"
  })
}

resource "aws_subnet" "vpc_network_private_backend_subnets" {
  count = length(local.private_backend_subnets)

  vpc_id = aws_vpc.vpc_network.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  cidr_block = local.private_backend_subnets[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-private-backend-subnet-${count.index}"
  })
}

resource "aws_subnet" "vpc_network_private_database_subnets" {
  count = length(local.private_database_subnets)

  vpc_id = aws_vpc.vpc_network.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  cidr_block = local.private_database_subnets[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-private-database-subnet-${count.index}"
  })
}

resource "aws_eip" "vpc_network_ng_eip" {
  count = length(var.public_frontend_subnets)

  tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-eip-${count.index}"
  })
  
}

resource "aws_nat_gateway" "vpc_network_ng" {
  count = length(var.public_frontend_subnets)
  subnet_id = aws_subnet.vpc_network_public_frontend_subnets[count.index].id

  allocation_id = aws_eip.vpc_network_ng_eip[count.index].id

  tags = {
      Name = "${local.prefix}-ng-${count.index}"
  }
}

resource "aws_route_table" "vpc_network_public_rt" {
    vpc_id = aws_vpc.vpc_network.id

    tags = {
        Name = "${local.prefix}-public-rt"
    }
}

resource "aws_route_table" "vpc_network_private_rt" {
  count = length(var.private_backend_subnets) + length(var.private_database_subnets)

  vpc_id = aws_vpc.vpc_network.id

  tags = {
      Name = "${local.prefix}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count = length(aws_subnet.vpc_network_public_frontend_subnets)

  subnet_id      = aws_subnet.vpc_network_public_frontend_subnets[count.index].id
  route_table_id = aws_route_table.vpc_network_public_rt.id
}

resource "aws_route_table_association" "private_backend_subnet_associations" {
  count = length(aws_subnet.vpc_network_private_backend_subnets)

  subnet_id      = aws_subnet.vpc_network_private_backend_subnets[count.index].id
  route_table_id = aws_route_table.vpc_network_private_rt[count.index].id
}

resource "aws_route_table_association" "private_database_subnet_associations" {
  count = length(aws_subnet.vpc_network_private_database_subnets)

  subnet_id      = aws_subnet.vpc_network_private_database_subnets[count.index].id
  route_table_id = aws_route_table.vpc_network_private_rt[count.index + length(aws_subnet.vpc_network_private_backend_subnets)].id
}

resource "aws_route" "nat_gateway_route_backend" {
  count = length(aws_subnet.vpc_network_private_backend_subnets)

  route_table_id         = aws_route_table.vpc_network_private_rt[count.index].id
  destination_cidr_block = local.everyWhere.cidr_block
  nat_gateway_id         = aws_nat_gateway.vpc_network_ng[count.index % length(aws_nat_gateway.vpc_network_ng)].id
}

resource "aws_route" "nat_gateway_route_database" {
  count = length(aws_subnet.vpc_network_private_database_subnets)

  route_table_id         = aws_route_table.vpc_network_private_rt[count.index + length(aws_subnet.vpc_network_private_backend_subnets)].id
  destination_cidr_block = local.everyWhere.cidr_block
  nat_gateway_id         = aws_nat_gateway.vpc_network_ng[count.index % length(aws_nat_gateway.vpc_network_ng)].id
}

resource "aws_route" "internet_gateway_route" {
  count = length(aws_subnet.vpc_network_public_frontend_subnets)
  route_table_id = aws_route_table.vpc_network_public_rt.id
  destination_cidr_block = local.everyWhere.cidr_block
  gateway_id = aws_internet_gateway.igw_network.id
}

# number of public subnets must be equal to the number of private subnets