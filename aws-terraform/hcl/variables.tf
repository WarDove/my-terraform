# Root Variables

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "private_sub_count" {}
variable "public_sub_count" {}
variable "ssh_acl" {}
variable "public_acl" {}

