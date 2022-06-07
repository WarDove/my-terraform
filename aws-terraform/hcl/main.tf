# Root main

data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source            = "./network"
  vpc_cidr          = local.vpc_cidr
  private_sub_count = var.private_sub_count
  public_sub_count  = var.public_sub_count
  max_subnets       = local.max_subnets
  private_cidrs     = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  public_cidrs      = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  aws_az_names      = data.aws_availability_zones.available.names
  security_groups   = local.security_groups
  db_sub_group      = true
}