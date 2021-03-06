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

# depends_on = [
#     aws_vpc.demo-vpc
#   ]
  
  tags = {
    Name = "demo-vpc-igw"
  }
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
#     aws_vpc.demo-vpc
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
#     aws_vpc.demo-vpc
#   ]
}

# EMR-Cluster Public subnet

resource "aws_subnet" "emr-pub-subnet01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"

  tags = {
    name = "emr-pub-subnet01"
  }
}

# RDS-DB subnets group

resource "aws_db_subnet_group" "rds-db-subnet-group" {
name = "rds-db-subnet-group"
subnet_ids = [aws_subnet.rds-db-pub-subnet01.id, aws_subnet.rds-db-pub-subnet02.id]

tags = {
    Name = "rds-db-subnet-group"
  }
 }

# Redshift Cluster subnet group

resource "aws_redshift_subnet_group" "redshift-subnet-group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift-pub-subnet01.id, aws_subnet.redshift-pub-subnet02.id]

tags = {
  
    Name = "redshift-subnet-group"
  }
}
