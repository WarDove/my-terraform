# ec2 outputs

output "private_instances" {
  value = aws_instance.ubuntu-focal-private
}
