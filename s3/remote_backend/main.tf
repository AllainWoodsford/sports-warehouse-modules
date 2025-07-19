# Intention of this Module/Bucket in S3 is to be a Remote backend
# will use use_lockfile so min version should be 1.11.0

resource "aws_s3_bucket" "this" {
  # Bucket name needs to be unique can include optional suffix
  bucket = var.bucket_suffix == null ? var.bucket : "${var.bucket}-${var.bucket_suffix}"
  
  tags = {
    Version = "0.4.5"
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
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption
    }
  }
}

# Explicitly block all public access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "deny" {
  bucket = aws_s3_bucket.this.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#policy is optional if the var.user_arn remains blank i.e. ""
data "aws_iam_policy_document" "policydata" {
  statement {
    sid    = "AllowTerraformAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.user_arn] # Replace with your role ARN
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "policy" {
  #we don't attach the policy if there isn't an arn entered
  count = length(var.user_arn) > 1 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.policydata.json
}