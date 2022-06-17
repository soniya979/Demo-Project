#VPC

resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames  = true
  
tags = {
    Name = "demo-vpc"
  }
}

# For internet access

resource "aws_internet_gateway" "demo-vpc-igw" {
  vpc_id = aws_vpc.demo-vpc.id

depends_on = [
    aws_vpc.demo-vpc
  ]
}

# RDS-MySQL public subnets in different AZs

resource "aws_subnet" "rds-db-pub-subnet01" {
vpc_id = aws_vpc.demo-vpc.id
cidr_block = "10.0.0.0/24"
availability_zone = "ap-south-1a"
map_public_ip_on_launch = "true"
}

resource "aws_subnet" "rds-db-pub-subnet02" {
vpc_id = aws_vpc.demo-vpc.id
cidr_block = "10.0.1.0/24"
availability_zone = "ap-south-1b"
map_public_ip_on_launch = "true"
}

#create redshift cluster subnets in different AZs

resource "aws_subnet" "redshift-pub-subnet01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "redshift-pub-subnet-1"
  }

# depends_on = [
#     aws_vpc.redshift_vpc
#   ]
}

resource "aws_subnet" "redshift-pub-subnet02" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "redshift-pub-subnet-2"
  }

# depends_on = [
#     aws_vpc.redshift_vpc
#   ]
}
