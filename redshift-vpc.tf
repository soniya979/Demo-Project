#VPC

resource "aws_vpc" "redshift_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames  = true
  
tags = {
    Name = "redshift-vpc"
  }
}


resource "aws_internet_gateway" "redshift_vpc_igw" {
  vpc_id = aws_vpc.redshift_vpc.id

depends_on = [
    aws_vpc.redshift_vpc
  ]
}


resource "aws_subnet" "redshift_subnet_1" {
  vpc_id     = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "redshift-subnet-1"
  }

depends_on = [
    aws_vpc.redshift_vpc
  ]
}

resource "aws_subnet" "redshift_subnet_2" {
  vpc_id     = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
tags = {
    Name = "redshift-subnet-2"
  }

depends_on = [
    aws_vpc.redshift_vpc
  ]
}


resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet_1.id, aws_subnet.redshift_subnet_2.id]

tags = {
  
    Name = "redshift-subnet-group"
  }
}


resource "aws_default_security_group" "redshift_security_group" {

 vpc_id     = aws_vpc.redshift_vpc.id

ingress {

   from_port   = 5439

   to_port     = 5439

   protocol    = "tcp"

   cidr_blocks = ["0.0.0.0/0"]

 }


tags = {

   Name = "redshift-sg"

 }

depends_on = [

   aws_vpc.redshift_vpc

 ]
}
