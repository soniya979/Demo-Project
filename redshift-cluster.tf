# launch Redshift_cluster select region same as emr

#attach policy awsquery editor, aws readonly redhsift to iam user.

resource "aws_redshift_cluster" "redshift-cluster-01" {
  cluster_identifier = "redshift-cluster-01"
  database_name      = "demordsdb"
  master_username    = "demordsuser"
  master_password    = "Demo$12345"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id

  iam_roles = [aws_iam_role.redshift_role.arn]

depends_on = [
    aws_vpc.redshift_vpc,
    aws_default_security_group.redshift_security_group,
    aws_redshift_subnet_group.redshift_subnet_group,
    aws_iam_role.redshift_role
  ]
}
