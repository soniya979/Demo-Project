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
db_subnet_group_name = aws_db_subnet_group.db-subnet-grp.id
# availablty_zone = "ap-south-1a"
deletion_protection = true
vpc_security_group_ids = [aws_security_group.rds-sg.id]

tags = {
  Name = "demordsDB"
  }
}


# DB-sunnets configuration

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


resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "SG for RDS MySQL server"
  vpc_id      = aws_vpc.redshift_vpc.id
  
  # Keep the instance private by only allowing traffic from the web server.
  
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_default_security_group.redshift_security_group.id]
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
