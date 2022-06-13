#create s3 bucket for backend

resource "aws_s3_bucket" "remote-backend" {

    bucket = "remote-backend"

  }


resource "aws_s3_bucket_acl" "remote-backend-acl" {

    bucket = aws_s3_bucket.remote-backend.id

    acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote-backend-versioning" {

  bucket = aws_s3_bucket.remote-backend.id

  versioning_configuration {

    status = "Enabled"
  }

}


resource "aws_s3_bucket_server_side_encryption_configuration" "remote-backend-encyption" {

  bucket = aws_s3_bucket.remote-backend.bucket

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "AES256"
    }
  }
}


#create dynamodb for statelock

resource "aws_dynamodb_table" "remote-backend-db-table-01" {

    name           = "remote-backend-db-table-01"
    hash_key       = "LockID"
    billing_mode   = "PROVISIONED"
    read_capacity  = 50
    write_capacity = 50

attribute {

    name = "LockID"
    type = "S"

  }

tags = {

    Name = "Terraform State Lock DBTable"

    }
}
