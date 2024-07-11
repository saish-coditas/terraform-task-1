resource "aws_s3_bucket" "task_bucket" {
  bucket = "task.saishkothawade.me"
}

resource "aws_s3_bucket_ownership_controls" "task_bucket" {
  bucket = aws_s3_bucket.task_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "task_bucket" {
  bucket                  = aws_s3_bucket.task_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "task_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.task_bucket, aws_s3_bucket_public_access_block.task_bucket]
  bucket     = aws_s3_bucket.task_bucket.id
  acl        = "public-read"
}

resource "aws_s3_object" "task_bucket_object1" {
  bucket = aws_s3_bucket.task_bucket.id
  key    = "index.html"
  source = "index.html"
  etag   = filemd5("index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "task_bucket_object2" {
  bucket = aws_s3_bucket.task_bucket.id
  key    = "error.html"
  source = "error.html"
  etag   = filemd5("error.html")
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "task_bucket" {
  bucket = aws_s3_bucket.task_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "task_bucket" {
  bucket = aws_s3_bucket.task_bucket.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::task.saishkothawade.me/*"
      }
    ]
  }
  EOF
}

output "bucket_link" {
  value = aws_s3_bucket_website_configuration.task_bucket.website_endpoint
}
