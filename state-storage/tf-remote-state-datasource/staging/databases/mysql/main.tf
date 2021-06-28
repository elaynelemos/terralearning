terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "tf-remote-state-example/staging/databases/mysql/terraform.tfstate"
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
  db_instance_class = "db.t2.micro"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terralearning-tf-remote-state-db"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = local.db_instance_class
  name              = "example_database"
  username          = "admin"
  password          = "password"
}
