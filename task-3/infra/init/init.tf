variable "aws_region" {
  default = "eu-central-1"
}

variable "env_name" {
  default = "nb-development"
}

locals {
  tf_state_lock_dynamodb_table_name = "${var.env_name}-terraform-remote-state-lock"
  tf_state_s3_bucket_name = "${var.env_name}-terraform-remote-state"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = local.tf_state_lock_dynamodb_table_name
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = local.tf_state_s3_bucket_name
}

resource "aws_s3_bucket_acl" "terraform_state_s3_bucket_acl" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "terraform_state_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.terraform_state_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cassandra_backups_s3_bucket_encryption_config" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "s3_bucket_name" {
  description = "s3 bucket name for Terraform remote state"
  value       = local.tf_state_s3_bucket_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table for Terraform remote state locks"
  value       = local.tf_state_lock_dynamodb_table_name
}