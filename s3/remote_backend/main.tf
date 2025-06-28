# Intention of this Module/Bucket in S3 is to be a Remote backend
# will use use_lockfile so min version should be 1.11.0

resource "aws_s3_bucket" "this" {
  # Bucket name needs to be unique can include optional suffix
  bucket = bucket_suffix == null ? var.bucket : "${var.bucket}-${var.bucket_suffix}"

  tags = {
    Version = "0.3.1"
    Encryption = var.encryption
  }

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning so we can see full revision history of state files
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.this.id
    
    versioning_configuration {
      status = "Enabled"
    }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.this

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption
    }
  }
}

# Explicitly block all public access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "deny" {
  bucket = aws_s3_bucket.this
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}