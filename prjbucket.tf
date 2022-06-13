#create s3 bucket for project01

resource "aws_s3_bucket" "project01-s3-data-bucket" {

   bucket = "project01-s3-data-bucket"

  }

resource "aws_s3_bucket_acl" "s3-raw-acl" {

    bucket = aws_s3_bucket.project01-s3-data-bucket.id

    acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-raw-data-versioning" {

  bucket = aws_s3_bucket.project01-s3-data-bucket.id

  versioning_configuration {

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-demo-encyption" {

  bucket = aws_s3_bucket.project01-s3-data-bucket.bucket

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "AES256"
    }
  }
}

#upload file into s3 bucket

resource "aws_s3_object" "raw-data-object01" {
  key                    = "rawdata"
  bucket                 = aws_s3_bucket.project01-s3-data-bucket.id
  source                 = "Demo-Project/housing_price_prediction.csv"
 server_side_encryption = "AES256"
  etag = filemd5("Demo-Project/housing_price_prediction.csv")
}
