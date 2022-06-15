resource "aws_db_instance" "rdss3db" {
allocated_storage = 10
identifier = "rdss3db"
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.28"
instance_class = "db.t3.micro"
name = "rdss3db"
username = "rdsdbadmin"
password = "rdsadmin$12345"
parameter_group_name = "default.mysql5.7"
skip_final_snapshot  = true
}
