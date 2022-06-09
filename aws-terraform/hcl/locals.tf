# Root Locals

locals {
  max_subnets = max(var.private_sub_count, var.public_sub_count)
  vpc_cidr    = "10.123.0.0/16"
}


locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security Group for Public Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.ssh_acl]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.public_acl]
        }
      }
    }
    rds = {
      name        = "rds_sg"
      description = "Security Group for Database Access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}