# TODO: Define the variable for aws_region
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  default = "default"
}

variable "lambda_function_name" {
  type = string
  default = "greet_lambda"
}

variable "runtime_environment" {
  type = string
  default = "python3.7"
}

variable "archive_filename" {
  type = string
  default = "greet_lambda.zip"
}

variable "lambda_handler" {
  type = string
  default = "greet_lambda.lambda_handler"
}