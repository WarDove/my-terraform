# root locals



################### Region-1 ####################

# RDS locals
locals {
  rds_region-1 = {
    mysql = {
      allocated_storage     = 10
      max_allocated_storage = 100
      engine_version        = "5.7"
      instance_class        = "db.t3.micro"
      subnet_group          = "private"
      db_name               = var.mysql-region-1.dbname
      db_username           = var.mysql-region-1.username
      db_password           = var.mysql-region-1.password
      identifier            = "mysql-main"
      skip_final_snapshot   = true
      multi_az              = false
      tags = {
        Name = "mysql-main"
      }
    }
  }
}

# Security group locals
locals {
  public_ssh_region-1_acl  = ["94.20.66.0/23"]
  public_http_region-1_acl = ["0.0.0.0/0"]

}

locals {
  security_groups_region-1 = { # you might consider to create it without for_each usage if security groups are going to be correlated, and don't forget to use `depends_on` meta argument.
    public = {
      name        = "public_sg"
      description = "Public access security group"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = local.public_ssh_region-1_acl
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = local.public_http_region-1_acl
        }
      }
    }
    private = {
      name        = "private_sg"
      description = "Private access security group"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr_region-1]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr_region-1]
        }
      }
    }
    rds = { #meant to be general for all rds, if to be created separately then rename it to engine type as in local.rds-region-<region number>
      name        = "rds_sg"
      description = "Security Group for Database Access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr_region-1]
        }
      }
    }
  }
}
