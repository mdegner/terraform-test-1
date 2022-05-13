resource "aws_s3_bucket" "mybucket" {
  # oak9: aws_s3_bucket_public_access_block is not configured
  # oak9: BucketEncryption is not configured
  # oak9: aws_s3_bucket.server_side_encryption_configuration is not configured
  # oak9: aws_s3_bucket.cors_rule.allowed_methods is not configured
  # oak9: aws_s3_bucket.cors_rule.allowed_methods should be set to any of GET,HEAD,POST
  bucket = "mybucket"
  acl = "public"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "b" {
  # oak9: PolicyDocument.Statement is not configured
  bucket = aws_s3_bucket.b.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}
