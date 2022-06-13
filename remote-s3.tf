#create s3 bucket for backend

resource "aws_s3_bucket" "remote01-s3-backend" {

    bucket = "remote01-s3-backend"

  }


resource "aws_s3_bucket_acl" "remote01-s3-backend-acl" {

    bucket = aws_s3_bucket.remote01-s3-backend.id

    acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote01-s3-backend-versioning" {

  bucket = aws_s3_bucket.remote01-s3-backend.id

  versioning_configuration {

    status = "Enabled"
  }

}


resource "aws_s3_bucket_server_side_encryption_configuration" "remote01-s3-backend-encyption" {

  bucket = aws_s3_bucket.remote01-s3-backend.bucket

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "AES256"
    }
  }
}


#create dynamodb for statelock

resource "aws_dynamodb_table" "remote01-s3-backend-db-table-01" {

    name           = "remote01-s3-backend-db-table-01"
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
