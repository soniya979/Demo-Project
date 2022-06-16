#create RDS-MSQL

resource "aws_db_instance" "rdss3db" {
identifier = "rdss3db"
storage_type = "gp2"
allocated_storage = 20
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
name = "rdss3db"
username = "rdsdbadmin"
password = "rdsadmin$12345"
parameter_group_name = "default.mysql8.0"
publicly_accessible = true
skip_final_snapshot  = true
db_subnet_group_name = aws_db_subnet_group.rds-db-subnet-grp.id
# availablty_zone = "ap-south-1a"
deletion_protection = true
vpc_security_group_ids = [aws_security_group.rds-sg.id]

tags = {
  Name = "demordsDB"
  }
}

# DB- public subnets configuration for internet access

resource "aws_subnet" "rds-db-pub-subnet1" {
vpc_id = aws_vpc.redshift_vpc.id
cidr_block = "10.0.5.0/24"
availability_zone = "ap-south-1a"
}

resource "aws_subnet" "rds-db-pub-subnet2" {
vpc_id = aws_vpc.redshift_vpc.id
cidr_block = "10.0.6.0/24"
availability_zone = "ap-south-1b"
}

#create public route tabel

resource "aws_route_table" "rdsdb-pubrt" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "rdsdb-pubrt"
  }
}

# Associate public subnets to public route tabel

resource "aws_route_table_association" "rdsdb-pubrtasso01" {
  subnet_id      = aws_subnet.rds-db-pub-subnet1.id
  route_table_id = aws_route_table.rdsdb-pubrt.id
}

resource "aws_route_table_association" "rdsdb-pubrtasso02" {
  subnet_id      = aws_subnet.rds-db-pub-subnet2.id
  route_table_id = aws_route_table.rdsdb-pubrt.id
}

#  route for interney gateway

resource "aws_route" "rdsdb-publicsnroute" {
  route_table_id = aws_route_table.rdsdb-pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.redshift_vpc_igw.id
}


#create Elastic_ip

resource "aws_eip" "rds-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.redshift_vpc_igw]
}

#create Nat-gateway to access private subnets

resource "aws_nat_gateway" "redshift_vpc_natgw" {
  allocation_id = aws_eip.rds-eip.id
  subnet_id = aws_subnet.rds-db-pub-subnet2.id
  depends_on = [aws_internet_gateway.redshift_vpc_igw]
}

#create private-route_tabel

resource "aws_route_table" "rds-db-pvtrt" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "rds-db-pvtrt"
  }
}

#Associate private subnets to private route tabel

resource "aws_route_table_association" "rdsdb-pvtrtasso01" {
  subnet_id      = aws_subnet.rds-db-subnet1.id
  route_table_id = aws_route_table.rds-db-pvtrt.id
}

resource "aws_route_table_association" "rdsdb-pvtrtasso02" {
  subnet_id      = aws_subnet.rds-db-subnet2.id
  route_table_id = aws_route_table.rds-db-pvtrt.id
}

#add route for nat-gateway

resource "aws_route" "rdsdb-privatesnroute" {
  route_table_id = aws_route_table.rds-db-pvtrt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.redshift_vpc_natgw.id
}

# DB-private subnets configuration

resource "aws_subnet" "rds-db-subnet1" {
vpc_id = aws_vpc.redshift_vpc.id
cidr_block = "10.0.3.0/24"
availability_zone = "ap-south-1a"
}

resource "aws_subnet" "rds-db-subnet2" {
vpc_id = aws_vpc.redshift_vpc.id
cidr_block = "10.0.4.0/24"
availability_zone = "ap-south-1b"
}

#creat a subnet group using the above subnets A and B

resource "aws_db_subnet_group" "db-subnet-grp" {
name = "db-subnet-grp"
subnet_ids = [aws_subnet.rds-db-subnet1.id, aws_subnet.rds-db-subnet2.id]

tags = {
    Name = "demo rds-DB subnet group"
  }
 }



#secutiry group for RDS-MYSQL

resource "aws_security_group" "demosg1" {
    name = "demosg1"
    vpc_id =  aws_vpc.redshift_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

}
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "SG for RDS MySQL server"
  vpc_id      = aws_vpc.redshift_vpc.id
  
  # Keep the instance private by only allowing traffic from the web server.
  
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.demosg1.id]
  }
  
  
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "demo-rds-security-group"
  }
}
