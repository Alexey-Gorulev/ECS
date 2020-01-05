data "aws_availability_zones" "az" {}

locals {
  az_list = join(", ", aws_subnet.public_subnets[*].availability_zone)
}

resource "aws_vpc" "project" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "${var.env}-vps"
  }
}

resource "aws_internet_gateway" "project" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "${var.env}-ig"
  }
}

#=====Public Subnet

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.project.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "project" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "rt_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.project.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

#=====Private Subnet
/*
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.project.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "project" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project.id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

resource "aws_route_table_association" "rt_association" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.project.id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}
*/
