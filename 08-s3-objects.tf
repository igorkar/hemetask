resource "null_resource" "s3_objects" {
  count = 3000

  provisioner "local-exec" {
    command = "aws s3 cp sample.txt s3://${aws_s3_bucket.lambda_bucket.bucket}/object-${count.index}.txt"
  }

  depends_on = [aws_s3_bucket.lambda_bucket]
}