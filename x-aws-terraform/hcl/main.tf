# root main

data "aws_availability_zones" "az-region-1" {
  state    = "available"
  provider = aws.region-1
}

module "network-region-1" {
  source = "./network-region-1"
  providers = {
    aws = aws.region-1
  }
  az_names      = data.aws_availability_zones.az-region-1.names
  vpc_cidr      = var.vpc_cidr
  private_cidrs = [for i in range(1, 16, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_cidrs  = [for i in range(2, 16, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}