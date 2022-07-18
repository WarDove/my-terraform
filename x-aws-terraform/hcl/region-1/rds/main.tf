# rds main


# Subnet groups
resource "aws_db_subnet_group" "rds_sub_group" {
  for_each   = var.subnets
  name       = "rds_${each.key}_sub_group"
  subnet_ids = each.value[*].id

  tags = {
    Name = "rds_${each.key}_sub_group"
  }
}

# RDS instances
resource "aws_db_instance" "main_rds" {
  for_each               = var.rds_instances
  allocated_storage      = each.value.allocated_storage
  max_allocated_storage  = each.value.max_allocated_storage
  engine                 = each.key
  engine_version         = each.value.engine_version
  instance_class         = each.value.instance_class
  db_subnet_group_name   = aws_db_subnet_group.rds_sub_group[each.value.subnet_group].name
  vpc_security_group_ids = var.rds_sg_id
  db_name                = each.value.db_name
  username               = each.value.db_username
  password               = each.value.db_password
  identifier             = each.value.identifier
  skip_final_snapshot    = each.value.skip_final_snapshot
  multi_az = each.value.multi_az
  tags = {
    Name = each.value.tags.Name
  }
}