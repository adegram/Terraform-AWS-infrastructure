resource "aws_s3_bucket" "company-bucket" {
  bucket = "company-vpc-tf-state-bucket"

  tags = {
    Name        = "Company-bucket"
  }
}

resource "aws_s3_bucket_versioning" "company-bucket-versioning" {
  bucket = aws_s3_bucket.company-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "company-bucket-encryption" {
  bucket = aws_s3_bucket.company-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "company-bucket-public-access-block" {
  bucket = aws_s3_bucket.company-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}