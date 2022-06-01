# Network Main

resource "random_id" "vpc_uuid" {
  byte_length = 8
}

resource "random_shuffle" "az_list" {
  input        = var.aws_az_names
  result_count = var.max_subnets
}

resource "aws_vpc" "org_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "org-vpc-${random_id.vpc_uuid.hex}"
  }
}

#========================= PUBLIC ==========================
resource "aws_subnet" "org_pub_sub" {
  count                   = var.public_sub_count
  vpc_id                  = aws_vpc.org_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "org-pub-sub-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "org_igw" {
  vpc_id = aws_vpc.org_vpc.id
  tags = {
    Name = "org-igw"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "org_pub_rt" {
  vpc_id = aws_vpc.org_vpc.id
  tags = {
    Name = "org_pub_rt"
  }
}

resource "aws_route" "pub_r" {
  route_table_id         = aws_route_table.org_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.org_igw.id
}

resource "aws_route_table_association" "org_pub_rt_a" {
  count          = var.public_sub_count
  subnet_id      = aws_subnet.org_pub_sub.*.id[count.index]
  route_table_id = aws_route_table.org_pub_rt.id
}
#========================= PRIVATE ==========================
resource "aws_subnet" "org_priv_sub" {
  count                   = var.private_sub_count
  vpc_id                  = aws_vpc.org_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "org-priv-sub-${count.index + 1}"
  }
}

resource "aws_default_route_table" "org_priv_rt" {
  default_route_table_id = aws_vpc.org_vpc.default_route_table_id
  tags = {
    Name = "org_priv_rt_main"
  }
}
#===================================================================







