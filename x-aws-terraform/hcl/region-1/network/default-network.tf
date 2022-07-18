# Importing default VPC and its dependencies except IGW 

resource "aws_default_vpc" "default_vpc" {
  count         = var.default_network_enabled ? 1 : 0
  force_destroy = true
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_subnet_azs" {
  for_each          = { for v in var.az_names : v => v if var.default_network_enabled }
  availability_zone = each.value
  force_destroy     = true
  depends_on        = [aws_default_vpc.default_vpc]
}

resource "aws_default_route_table" "default_rt" {
  count                  = var.default_network_enabled ? 1 : 0
  depends_on             = [aws_default_vpc.default_vpc]
  default_route_table_id = aws_default_vpc.default_vpc[0].default_route_table_id
  route                  = []
  tags = {
    Name = "default-route-table"
  }
}

resource "aws_default_security_group" "default_sg" {
  count      = var.default_network_enabled ? 1 : 0
  depends_on = [aws_default_vpc.default_vpc]
  vpc_id     = aws_default_vpc.default_vpc[0].id
}

resource "aws_default_network_acl" "default_nacl" {
  count                  = var.default_network_enabled ? 1 : 0
  depends_on             = [aws_default_vpc.default_vpc]
  default_network_acl_id = aws_default_vpc.default_vpc[0].default_network_acl_id
}

resource "aws_default_vpc_dhcp_options" "default_dhcp" {
  count      = var.default_network_enabled ? 1 : 0
  depends_on = [aws_default_vpc.default_vpc]
}

resource "aws_internet_gateway" "default-vpc-igw" {
  count      = 0 #var.default_network_enabled ? 1 : 0
  depends_on = [aws_default_vpc.default_vpc]
  vpc_id     = aws_default_vpc.default_vpc[0].id
  tags = {
    Name = "default-vpc-igw"
  }
}
