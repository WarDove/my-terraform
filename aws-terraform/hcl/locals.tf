locals {
  max_subnets = max(var.private_sub_count, var.public_sub_count)
  vpc_cidr    = "10.123.0.0/16"
}