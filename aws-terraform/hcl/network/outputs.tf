# Network outputs

output "vpc_id" {
  value = aws_vpc.org_vpc.id
}

output "rds_sub_group" {
  value = aws_db_subnet_group.rds_sub_group
}

output "vpc_sg_list" {
  value = aws_security_group.org_sg
}

output "public_subnets" {
  value       = aws_subnet.org_pub_sub
  description = "List of public subnets"
}