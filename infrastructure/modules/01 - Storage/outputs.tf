output "s3_storage_bucket_name" {
  value = aws_s3_bucket.s3_storage.bucket
}

output "s3_storage_bucket_arn" {
  value = aws_s3_bucket.s3_storage.arn
}

output "s3_storage_bucket_id" {
  value = aws_s3_bucket.s3_storage.id
}

output "s3_storage_bucket_domain_name" {
  value = aws_s3_bucket.s3_storage.bucket_domain_name
}