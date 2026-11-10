output aws_s3_bucket_public_access_block {
  description = "The Public access block configuration for the S3 bucket"
  value = aws_s3_bucket_public_access_block.company-bucket-public-access-block.bucket
}

output aws_s3_bucket {
  description = "The S3 bucket configuration"
  value = aws_s3_bucket.company-bucket.bucket
}

output aws_s3_bucket_versioning {
  description = "The Versioning configuration for the S3 bucket"
  value = aws_s3_bucket_versioning.company-bucket-versioning.bucket
}

output aws_s3_bucket_server_side_encryption_configuration {
  description = "The Server-side Encryption configuration for the S3 bucket"
  value = aws_s3_bucket_server_side_encryption_configuration.company-bucket-encryption.bucket
}
