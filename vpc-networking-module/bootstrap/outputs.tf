output aws_s3_bucket_public_access_block {
  description = "The public access block configuration for the S3 bucket"
  value = aws_s3_bucket_public_access_block.company-bucket-public-access-block.bucket
}

output aws_s3_bucket {
  description = "The S3 bucket configuration"
  value = aws_s3_bucket.company-bucket.bucket
}

output aws_s3_bucket_versioning {
  description = "The versioning configuration for the S3 bucket"
  value = aws_s3_bucket_versioning.company-bucket-versioning.bucket
}

output aws_s3_bucket_server_side_encryption_configuration {
  description = "The server-side encryption configuration for the S3 bucket"
  value = aws_s3_bucket_server_side_encryption_configuration.company-bucket-encryption.bucket
}