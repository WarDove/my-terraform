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
  private_cidrs           = [for i in range(1, 16, 2) : cidrsubnet(var.vpc_cidr_region-1, 8, i)]
  public_cidrs            = [for i in range(2, 16, 2) : cidrsubnet(var.vpc_cidr_region-1, 8, i)]
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
  rds_sg_id        = module.network-region-1.sg_map["rds"].id[*]
  subnets       = module.network-region-1.subnet_map_list
  rds_instances = local.rds_region-1
}