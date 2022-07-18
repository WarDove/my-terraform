#!/bin/bash

terraform import module.network-region-1.aws_internet_gateway.default-vpc-igw[0] \
	$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,\
	Values=$(aws ec2 describe-vpcs --filters 'Name=is-default,Values=[true]'\
	 --region us-east-2 --output text --query 'Vpcs[].VpcId')" --region us-east-2\
	  --output text --query 'InternetGateways[].InternetGatewayId') 2> /dev/null \
	  || echo "No IGW Resource to Import"
	  
	  
	  
	  
