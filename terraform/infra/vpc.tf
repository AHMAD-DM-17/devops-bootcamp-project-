resource "aws_vpc" "devops" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name = "devops-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops.id
  tags   = merge(local.tags, { Name = "devops-igw" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops.id
  cidr_block              = local.public_subnet_cidr
  availability_zone       = local.az
  map_public_ip_on_launch = false

  tags = merge(local.tags, { Name = "devops-public-subnet" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.devops.id
  cidr_block        = local.private_subnet_cidr
  availability_zone = local.az

  tags = merge(local.tags, { Name = "devops-private-subnet" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops.id
  tags   = merge(local.tags, { Name = "devops-public-route" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.tags, { Name = "devops-nat-eip" })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags          = merge(local.tags, { Name = "devops-ngw" })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.devops.id
  tags   = merge(local.tags, { Name = "devops-private-route" })
}

resource "aws_route" "private_out" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
