terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "global/s3/terraform.tfstate"
    region = "sa-east-1"

    dynamodb_table = "elemos-terralearning-state-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  bucket_name   = "elemos-${var.name}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.bucket_name}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
