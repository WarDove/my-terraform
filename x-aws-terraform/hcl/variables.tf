# root variables


# Provider and Backend variables

variable "profile" {}
variable "region-bck" {}
variable "region-1" {}
variable "region-2" {}
variable "region-3" {}
variable "region-4" {}


################### Region -1 ####################

variable "vpc_cidr_region-1" {}
variable "default_network_enabled_region-1" {}
variable "public_ngw_enabled_region-1" {}
variable "ec2_enabled_region-1" {}
variable "elb_enabled_region-1" {}
variable "rds_enabled_region-1" {}
variable "mysql-region-1" {
  type = map(string)
}