resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/get-s3-objects"
  retention_in_days = 14
}