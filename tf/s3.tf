# Create an IAM role for s3 to communicate with server
resource "aws_iam_role" "s3_role" {
    name = "cust_s3_role"
    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "bucket" {
  bucket = "hogehogebucket" # CHANGE TO ADD NAME TO S3 BUCKET
  acl    = "private"
  versioning {
  enabled = true
}
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-2.s3" # CHANGE TO MATCH REGION OF CHOICE
  route_table_ids = [aws_route_table.route.id]
  policy = <<POLICY
{
  "Statement": [
      {
          "Action": "*",
          "Effect": "Allow",
          "Resource": "*",
          "Principal": "*"
      }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "s3_policy" {
    name = "s3_policy"
    role = aws_iam_role.s3_role.id
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": [
      "s3:*"
    ],
    "Effect": "Allow",
    "Resource": "*"
  }
]
}
EOF
}