# root tfvars

################### WARNING ####################

# if `default_network_resources_region-1` set to `true` you will need to import 
# the igw attached to default-vpc before terraform apply


################### General ####################

profile    = "default"
region-bck = "us-east-1"
region-1   = "us-east-2"
region-2   = "none"
region-3   = "none"
region-4   = "none"


################### Region 1 ####################

vpc_cidr_region-1                = "10.0.0.0/16"
default_network_enabled_region-1 = false
public_ngw_enabled_region-1      = false
ec2_enabled_region-1             = true
elb_enabled_region-1             = false
rds_enabled_region-1             = false

mysql-region-1 = {
  dbname   = "root"
  username = "admin"
  password = "verystrongpass"
}
# this auth credentials can be fetched to an ec2 instance with the help of templatefile function and ec2 user_data property and bash script execution within the regarding user_data
