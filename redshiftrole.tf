#create redshift-customize role with s3 readonly access permission.

resource "aws_iam_role_policy" "s3_full_access_policy" {
  name = "redshift_s3_policy"
  role = aws_iam_role.redshift_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = ["s3:*"]
            Resource = "*"
        },
]
})

}


resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"
 
assume_role_policy = jsonencode({

  Version = "2012-10-17"
  Statement = [ 
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid = ""
      Principal = {
      Service = "redshift.amazonaws.com"
      }      
    },
  ]
})

tags = {
    tag-key = "redshift-role"
  }
}
