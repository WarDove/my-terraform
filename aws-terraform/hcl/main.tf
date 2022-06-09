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

module "loadbalancing" {
  source         = "./loadbalancing"
  public_subnets = module.network.public_subnets[*].id
  public_sg      = module.network.vpc_sg_list["public"].id[*]
}

# module "database" {
#   source                 = "./database"
#   allocated_storage      = 10
#   max_allocated_storage  = 100
#   db_engine_version      = "5.7"
#   db_instance_class      = "db.t3.micro"
#   dbname                 = var.dbname
#   dbuser                 = var.dbuser
#   dbpassword             = var.dbWpassword
#   db_subnet_group_name   = module.network.rds_sub_group[0].name
#   vpc_security_group_ids = module.network.vpc_sg_list["rds"].id[*]
#   db_identifier          = "k3s-cp-db-main"
#   skip_db_snapshot       = true
# }
