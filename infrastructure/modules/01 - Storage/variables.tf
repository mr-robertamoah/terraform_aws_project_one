variable "bucket_name" {
  description = "the name of the s3 bucket meant for logging"
  type = string
}

variable "enable_versioning" {
  description = "enable versioning for the s3 bucket"
  type = bool
  default = false
}
