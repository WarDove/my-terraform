# network main

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc_cidr}"
  }
}

# IGW
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Internet facing NGW and EIP
resource "aws_eip" "ngw_eip" {
  count = var.public_ngw_enabled ? local.az_count : 0
  vpc   = true
  tags = {
    Name = "ngw-eip-${var.az_names[count.index]}"
  }
}

resource "aws_nat_gateway" "public_ngw" {
  count         = var.public_ngw_enabled ? local.az_count : 0
  allocation_id = aws_eip.ngw_eip[count.index].id
  subnet_id     = aws_subnet.private_subnet[count.index].id

  tags = {
    Name = "ngw-${var.az_names[count.index]}"
  }

  depends_on = [aws_internet_gateway.main_igw, aws_eip.ngw_eip]
}

# Route Tables
resource "aws_default_route_table" "rt_main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "rt_main"
  }
}

resource "aws_route_table" "public_rt" {
  count  = local.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${upper(substr(var.az_names[count.index], -1, 1))} public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  count  = local.az_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${upper(substr(var.az_names[count.index], -1, 1))} private-rt"
  }
}

resource "aws_route" "ngw_route" {
  count                  = var.public_ngw_enabled ? local.az_count : 0
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_ngw[count.index].id
  depends_on             = [aws_route_table.private_rt, aws_nat_gateway.public_ngw]
}

resource "aws_route_table_association" "public_rta" {
  count          = local.az_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index] #alternative aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_route_table_association" "private_rta" {
  count          = local.az_count
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_rt[count.index].id
}

# Subnets
resource "aws_subnet" "private_subnet" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.az_names[count.index]
  tags = {
    Name = "${upper(substr(var.az_names[count.index], -1, 1))} private"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.az_names[count.index]
  tags = {
    Name = "${upper(substr(var.az_names[count.index], -1, 1))} public"
  }
}

# Security groups
resource "aws_security_group" "main" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}