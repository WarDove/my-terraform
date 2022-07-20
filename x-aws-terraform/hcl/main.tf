# root main

data "aws_availability_zones" "az-region-1" {
  state    = "available"
  provider = aws.region-1
}

module "network-region-1" {
  source = "./region-1/network"
  providers = {
    aws = aws.region-1
  }
  az_names                = data.aws_availability_zones.az-region-1.names
  vpc_cidr                = var.vpc_cidr_region-1
  private_cidrs           = local.private_cidrs_region-1
  public_cidrs            = local.public_cidrs_region-1
  security_groups         = local.security_groups_region-1
  public_ngw_enabled      = var.public_ngw_enabled_region-1
  default_network_enabled = var.default_network_enabled_region-1
}

module "rds-region-1" {
  count  = var.rds_enabled_region-1 ? 1 : 0
  source = "./region-1/rds"
  providers = {
    aws = aws.region-1
  }
  rds_sg_id     = module.network-region-1.sg_map["rds"].id[*]
  subnets       = module.network-region-1.subnet_map_list
  rds_instances = local.rds_region-1
}
# Note: Alternative with `for_each`, motivation: separate rds databases with segregated security groups
# Recipe: Creating RDS locals with respective name, Creating security_groups with respective name
# using each.key within rds_sg_id instead of hardcoded one-for-all "rds" sg.
# for_each = { for k v in local.rds_region-1: k => v if var.rds_enabled_region-1 }
# rds_instances = each.value


module "ec2-region-1" {
  count  = var.ec2_enabled_region-1 ? 1 : 0
  source = "./region-1/ec2"
  providers = {
    aws = aws.region-1
  }
  az_names      = data.aws_availability_zones.az-region-1.names
  sg_map        = module.network-region-1.sg_map
  subnets       = module.network-region-1.subnet_map_list
  private_cidrs = local.private_cidrs_region-1
  public_cidrs  = local.public_cidrs_region-1
}