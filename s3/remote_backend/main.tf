resource "aws_s3_bucket" "this" {
  #Bucket name needs to be unique can include optional suffix
  bucket = bucket_suffix == null ? var.bucket : "${var.bucket}-${var.bucket_suffix}"
  
  tags = {
    Version = "0.1.0"
    Encryption = ""
  }

  #Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}