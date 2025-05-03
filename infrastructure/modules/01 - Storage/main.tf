resource "aws_s3_bucket" "s3_storage" {
  bucket = "${local.prefix}-${var.bucket_name}"

  tags = merge(
    local.tags,
    {
      Name        = "${local.prefix}-${var.bucket_name}"
    })
}

resource "aws_s3_bucket_versioning" "s3_storage_versioning" {
  bucket = aws_s3_bucket.s3_storage.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_storage_encryption" {
  bucket = aws_s3_bucket.s3_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}