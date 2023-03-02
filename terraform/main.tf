terraform {
  # backend "s3" {
  #   bucket         = "terraform-current-state"
  #   key            = "global/s3/terraform.tfstate"
  #   region         = "us-east-2"

  #   dynamodb_table = "terraform-current-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region  = "us-east-2"
}

# Bucket to store terraform "up and running" state
resource "aws_s3_bucket" "terraform_current_state" {
  bucket = "terraform-current-state"
  # The following should be used to ensure there is no accidental deletion
  # For this project, enable deletion
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Enable versioning on the s3 bucket
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_current_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server Side Encryption by default for anything written to the s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_current_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_current_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamboDB Table to lock Terraform state, need to look into billing in AWS free tier
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-current-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
