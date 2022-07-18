# network outputs

output "vpc_id" {
  value = aws_vpc.main.id
}

output "sg_map" {
  value       = aws_security_group.main
  description = "Map of subnet groups"
}

output "subnet_map_list" {
  value = { private = aws_subnet.private_subnet, public = aws_subnet.public_subnet }
}
