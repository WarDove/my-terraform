# Network outputs

output "vpc_id" {
  value = aws_vpc.org_vpc.id
}

output "public_sg_id" {
  value = aws_security_group.org_sg["public"].id
}