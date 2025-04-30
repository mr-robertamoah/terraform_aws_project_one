provider "aws" {
  region = var.region
  # Optionally, you can specify the profile if you're using named profiles in your AWS credentials file
  profile = var.aws_profile
}