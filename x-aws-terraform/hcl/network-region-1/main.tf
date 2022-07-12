# network main

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc_cidr}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.az_names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.az_names[count.index]
  tags = {
    Name = "${upper(substr(var.az_names[count.index],-1,1))} private"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.az_names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.az_names[count.index]
  tags = {
    Name = "${upper(substr(var.az_names[count.index],-1,1))} public"
  }
}
