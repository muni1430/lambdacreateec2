provider "aws" {
  region="us-east-1"
}
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "new_one_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime = "python3.9"
}
resource "aws_s3_bucket" "b" {
  bucket = "new bucket"
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
