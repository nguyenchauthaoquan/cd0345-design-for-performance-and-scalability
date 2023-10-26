provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "archive_file" "archive" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = var.archive_filename
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
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

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "greet_lambda" {
  function_name = var.lambda_function_name
  filename = var.archive_filename
  role          = aws_iam_role.lambda_iam_role.arn
  handler = var.lambda_handler
  source_code_hash = data.archive_file.archive.output_base64sha256
  runtime = var.runtime_environment
  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
  environment {
    variables = {
      greeting = "Hi there, My name is Quan!"
    }
  }
}